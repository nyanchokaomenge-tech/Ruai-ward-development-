-- Ruai Ward Development: Supabase setup
-- Run this entire file in Supabase Dashboard → SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.ward_feedback (
  id uuid primary key default gen_random_uuid(),
  reference_code text not null unique default ('RWD-' || upper(encode(gen_random_bytes(6), 'hex'))),
  category text not null check (char_length(category) <= 100),
  area text not null check (char_length(area) <= 100),
  details text not null check (char_length(details) between 1 and 2500),
  resident_name text null check (char_length(coalesce(resident_name, '')) <= 100),
  resident_contact text null check (char_length(coalesce(resident_contact, '')) <= 120),
  consent boolean not null default false check (consent = true),
  status text not null default 'Received'
    check (status in ('Received','Under review','In progress','Resolved','Unable to proceed')),
  admin_response text null check (char_length(coalesce(admin_response, '')) <= 3000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.ward_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create or replace function public.is_ward_admin()
returns boolean language sql stable security definer
set search_path = public
as $$
  select exists(select 1 from public.ward_admins where user_id = auth.uid());
$$;

create or replace function public.set_feedback_updated_at()
returns trigger language plpgsql
as $$ begin new.updated_at = now(); return new; end; $$;

drop trigger if exists ward_feedback_updated_at on public.ward_feedback;
create trigger ward_feedback_updated_at before update on public.ward_feedback
for each row execute function public.set_feedback_updated_at();

alter table public.ward_feedback enable row level security;
alter table public.ward_admins enable row level security;

drop policy if exists "Public can submit feedback with consent" on public.ward_feedback;
create policy "Public can submit feedback with consent"
on public.ward_feedback for insert to anon, authenticated
with check (consent = true);

drop policy if exists "Ward admins can read submissions" on public.ward_feedback;
create policy "Ward admins can read submissions"
on public.ward_feedback for select to authenticated
using (public.is_ward_admin());

drop policy if exists "Ward admins can update submissions" on public.ward_feedback;
create policy "Ward admins can update submissions"
on public.ward_feedback for update to authenticated
using (public.is_ward_admin())
with check (public.is_ward_admin());

drop policy if exists "Admins can view own admin record" on public.ward_admins;
create policy "Admins can view own admin record"
on public.ward_admins for select to authenticated
using (user_id = auth.uid());

-- Public lookup returns only a case reference, status and public-facing response.
-- It deliberately does not return the resident's name, contact or issue details.
create or replace function public.lookup_ward_feedback(p_reference text)
returns table(reference_code text, status text, admin_response text, updated_at timestamptz)
language sql stable security definer
set search_path = public
as $$
  select f.reference_code, f.status, f.admin_response, f.updated_at
  from public.ward_feedback f
  where upper(f.reference_code) = upper(trim(p_reference))
  limit 1;
$$;

revoke all on function public.lookup_ward_feedback(text) from public;
grant execute on function public.lookup_ward_feedback(text) to anon, authenticated;

revoke all on public.ward_feedback from anon, authenticated;
grant insert on public.ward_feedback to anon, authenticated;
grant select, update on public.ward_feedback to authenticated;
revoke all on public.ward_admins from anon, authenticated;
grant select on public.ward_admins to authenticated;

-- AFTER creating the first administrator account in Supabase Authentication,
-- copy that user's UUID and run this separately:
-- insert into public.ward_admins (user_id) values ('PASTE-AUTH-USER-UUID-HERE');
-- Never allow public signup for administrators. Create accounts from the Supabase dashboard.

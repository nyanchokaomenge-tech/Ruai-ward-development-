# Ruai Ward Development

Mobile-friendly resident feedback site for Ruai Ward.

## Project files
- `index.html` — resident submission form and WhatsApp/email handoff.
- `track.html` — public status lookup by reference code (reveals status and public response only).
- `admin.html` — administrator sign-in and case dashboard.
- `config.js` — public Supabase project URL and anon/publishable key placeholders.
- `supabase-schema.sql` — database tables, row-level security, status lookup function and administrator policies.
- `.github/workflows/pages.yml` — GitHub Pages deployment workflow.

## Backend setup still required
I cannot provision a Supabase project or create its account credentials on your behalf from this repository connection. Complete these steps to enable real central submissions, responses and tracking:

1. Create a Supabase project at https://supabase.com/ and keep the database password private.
2. In Supabase → SQL Editor, run the complete contents of `supabase-schema.sql`.
3. In Supabase → Project Settings → API, copy the project URL and **anon/publishable** key into `config.js`. These are browser-facing values protected by the database policies. **Never put a service-role key or database password in this file or GitHub.**
4. In Supabase → Authentication, create the administrator account with the ward team's authorized email and a strong unique password. Disable public sign-ups if not needed.
5. Copy that account's user UUID from Authentication and run this separate SQL command in the SQL Editor, replacing the placeholder:
   `insert into public.ward_admins (user_id) values ('PASTE-AUTH-USER-UUID-HERE');`
6. Open `admin.html`, sign in and confirm that only the authorized account can see/update submissions.
7. Submit a test issue, note the returned reference code, then test `track.html` and an administrator status/response update. Delete test records before launch if appropriate.

## Contact channels
- WhatsApp: +254 742 620 609
- Email: nyanchokaomenge@gmail.com

The resident form can prepare a WhatsApp or email draft for a resident to review and send. Automatic email notifications are not enabled; they require a server-side email provider and secret credentials stored only in server-side secrets. Do not put those credentials in browser code.

## Publish with GitHub Pages
1. Open repository Settings → Pages.
2. Select **GitHub Actions** as the source.
3. Open Actions and confirm the Pages workflow succeeds.
4. Return to Settings → Pages for the published URL.

Repository: https://github.com/nyanchokaomenge-tech/Ruai-ward-development-

## Privacy and limitations
- Before backend setup, the app does not centrally save submissions or enable real tracking.
- Once configured, submissions include issue details and optional name/contact details. Access to those records is restricted by row-level security to administrators.
- Public reference lookup returns only reference, status, administrator response and update time; it does not expose resident contact details or issue text.
- Reference codes should be treated as private. Do not share them publicly.
- Add a formal privacy notice, retention/deletion schedule, backups, abuse protection, and incident process before inviting all residents to use the service.
- Test database policies and the administrator workflow before public launch.

# Ruai Ward Development

Mobile-friendly resident feedback prototype for Ruai Ward.

## Included
- Responsive feedback form with issue category, area, description, optional contact details.
- Consent checkbox and privacy reminders.
- WhatsApp message draft to 0742 620 609.
- Email draft to nyanchokaomenge@gmail.com.
- Browser-generated reference code for residents to quote in follow-up.
- GitHub Pages deployment workflow at .github/workflows/pages.yml.

## Current limitations — read before launch
This is a front-end prototype, not yet a production case-management system. The resident must choose WhatsApp/email and press Send. The generated reference code is not registered in a central database. There is no secure administrator login, shared status tracking, central submissions database, administrator response dashboard, or automatic email delivery.

## Required before real resident engagement
1. Add a secure backend/database (such as Supabase or Firebase) with least-privilege access rules.
2. Add administrator authentication and a dashboard for submissions, responses, and status changes.
3. Configure a server-side email provider and verified sender credentials. Never put API keys/secrets in browser code or GitHub.
4. Publish a privacy notice and retention/deletion policy; add abuse protection, backups, and test access controls.
5. Confirm the ward team controls the listed contact channels and test the workflow before public launch.

## Publish with GitHub Pages
1. Open repository Settings → Pages.
2. Select **GitHub Actions** as the deployment source.
3. Open Actions and check the workflow run after pushing to main.
4. When it succeeds, Settings → Pages will show the published website URL.

Repository: https://github.com/nyanchokaomenge-tech/Ruai-ward-development-

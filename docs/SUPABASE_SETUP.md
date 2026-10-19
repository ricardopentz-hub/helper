# Supabase setup (step-by-step)

1) Create a Supabase project
   - Go to https://app.supabase.com and create a new project.
   - Note the Project URL (SUPABASE_URL) and the Project API Keys (anon & service_role). Keep the service_role key secret.

2) Create the notes table
   - In Supabase SQL editor, run docs/SUPABASE_SCHEMA.sql.

3) Enable Sign In with Apple
   - In Supabase dashboard -> Authentication -> Settings -> External OAuth Providers, configure Apple with your Service ID and key from Apple Developer portal.
   - Make sure the callback URLs include the ones you'll use (Vercel functions or your own server).

4) Configure Row Level Security (RLS)
   - The supplied SQL creates an RLS policy that uses auth.uid(). Verify RLS is enabled and the policy appears.

5) Create API keys and service role
   - For server-side Vercel functions use the SUPABASE_SERVICE_ROLE_KEY (never include this in the client).
   - Client-side iOS will use the anon key for direct Supabase operations if you choose, or supply server-issued JWTs.

6) Test manual requests
   - Use PostgREST REST endpoints (auto-generated) to test notes queries with curl, or use the Supabase dashboard table editor.

Notes on auth flow for iOS + Apple Sign-in
- You can either let Supabase handle OAuth redirects for Sign in with Apple (opens a web flow) or implement native Sign in with Apple on iOS and exchange the Apple identity token on the server for a Supabase session.
- For a production App Store app, use native Sign in with Apple for the best UX and compliance.

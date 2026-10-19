# Helper — iOS MVP (SwiftUI)

This repository contains a minimal scaffold for the Helper iOS MVP: a small SwiftUI app that helps people "write down their thoughts" and a backend plan using Supabase + Vercel for auth, persistence, and secure OpenAI integration.

Quickstart (local)
1. Open Xcode and create a new iOS App target (or import these Sources into an Xcode project).
2. Ensure project deployment target is iOS 27.0.1 (or adjust if your Xcode doesn't yet support it).
3. Add the files under Sources/HelperApp to your app target, or add the Swift package (see Package.swift) as a dependency.
4. Run the app in Simulator. The single screen lets you type quick notes and saves locally.

MVP goal
- One screen where a user can quickly capture a thought and have it persisted locally and synced to a backend when online.
- Later: expose an API on the backend that can call OpenAI (server-side) to provide enhancements (summaries, tags, etc.).

What's included
- Simple SwiftUI App skeleton (Sources/HelperApp)
- ViewModel with local persistence placeholder and sync stubs
- Unit test for ViewModel (Tests/HelperAppTests)
- docs/USER_STORIES.md
- docs/BACKEND_PLAN.md (Supabase + Vercel)
- GitHub Actions CI workflow to run swift test
- CONTRIBUTING.md and ISSUE_TEMPLATE.md

Notes
- I scaffolded a Swift Package layout and small SwiftUI files that are safe to copy into an Xcode project. Xcode's auto-generated .xcodeproj is not included.
- I committed directly to main as requested. If you want this moved to a branch later, I can create one and open a PR.

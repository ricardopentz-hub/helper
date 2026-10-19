# User Stories and Acceptance Criteria

## Primary user story
- Title: Capture a thought quickly
- As a user, I want to open Helper, write down a thought, and save it so I can find it later.

Acceptance criteria (MVP)
- The app opens to a single screen and focuses the editor quickly.
- The user can type free-form text and tap Save.
- After Save, the note appears in a list (or confirmation) and is persisted locally.
- The app shows an indicator when offline vs online sync state (basic). Sync to backend may be deferred until connectivity is available.

## Secondary stories
- As a user, I want my notes persisted locally so I don't lose them if I close the app.
- As a user, I want to sign in (later) with Sign In with Apple; the backend plan supports it.

Minimum acceptance
- 1 unit test covering the ViewModel's save/load behavior.
- CI runs tests successfully on push.

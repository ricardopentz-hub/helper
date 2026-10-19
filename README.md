# HelperApp

This repository contains a native SwiftUI iOS app named HelperApp.

## Overview

HelperApp is a lightweight tab-based application for iOS that includes:

- Home tab with greeting, quick tips, and a simple counter
- Tasks tab for adding, toggling, and deleting tasks
- Settings tab showing bundle information and app version
- Local persistence using UserDefaults and JSON encoding
- iOS deployment target: 16.1
- Bundle identifier: com.ricardopentz-hub.helper

## Project structure

- `HelperApp.xcodeproj` — Xcode project
- `HelperApp/` — SwiftUI app source files
- `.github/workflows/` — GitHub Actions workflows
- `README.md` — project documentation

## How to open the app

Open `HelperApp.xcodeproj` in Xcode 14+ and run the app.

### Run on the iOS simulator

1. Open the project in Xcode.
2. Select a simulator device (for example, iPhone 14).
3. Press the Run button.

This is the quickest way to test the app locally without Apple Developer credentials.

### Run on a physical iOS device

1. Connect your iPhone or iPad to your Mac.
2. Open the Xcode project.
3. Select your device as the run target.
4. Go to the project target settings and configure Signing:
   - Select a valid Apple Developer account or team
   - Ensure the bundle identifier matches a valid App ID
5. Build and run the app.

Notes:

- A paid Apple Developer Program is required for full device distribution, TestFlight, or App Store submission.
- For local device testing, a valid Apple ID and signing profile may still be required depending on your Xcode and Apple account setup.
- If you see a signing error, check the bundle identifier and team configuration in Xcode.

## GitHub Actions

This repository includes GitHub Actions workflows for CI.

### CI workflow for simulator build and test

File: `.github/workflows/ci-simulator.yml`

This workflow is designed for build verification on GitHub-hosted macOS runners. It triggers on merges to `main` and runs a simulator build/test flow for the iOS app.

It is suitable for validating the app without requiring Apple signing secrets.

### Generic CI workflow

File: `.github/workflows/ci.yml`

This is a generic pull request merge workflow that triggers when a feature branch is merged into `main` and performs placeholder build and test steps.

It is intentionally generic and should be adjusted to your actual commands, for example:

- `npm ci && npm test`
- `pytest`
- `./gradlew test`
- `xcodebuild ...` for iOS builds

## CI behavior

The repository currently contains:

- A simulator-focused GitHub Action for iOS build validation
- A generic merge-to-main workflow with placeholder commands

The app itself is a native iOS SwiftUI project and does not currently include a dedicated test target in the Xcode project; therefore, the simulator workflow is mainly intended to validate compile/build health unless additional test targets are added.

## Development notes

- The project uses `UserDefaults` for local task persistence.
- The app does not currently include a production signing pipeline or TestFlight upload flow.
- App icons and additional branding can be added later under `HelperApp/Assets.xcassets`.

## License

This project is licensed under the MIT License. See `LICENSE` for details.

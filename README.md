# HelperApp

This repository now contains an enhanced SwiftUI iOS app named "HelperApp".

What's included in this update:
- Tab-based SwiftUI app (Home / Tasks / Settings)
- Tasks: add, toggle complete, delete; tasks persist locally using UserDefaults (JSON-encoded)
- Home: greeting, quick tips and simple counter
- Settings: shows bundle ID and app version, a UI-only toggle stored with @AppStorage
- Deployment target: iOS 16.1
- Bundle identifier: com.ricardopentz-hub.helper

How to open:
- Open `HelperApp.xcodeproj` in Xcode 14+ and run on a simulator or device after setting a signing team.

Notes:
- You can upload custom app icons later to `HelperApp/Assets.xcassets`.
- Signing & provisioning must be configured in Xcode to run on a physical device.

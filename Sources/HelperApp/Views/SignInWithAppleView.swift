import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton()
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}

// Example usage: show this button and handle the ASAuthorizationController delegate in your app

// Notes:
// - After obtaining the credential's identityToken, send it to your server (/api/auth/apple) to exchange for a Supabase session.
// - Alternatively, configure Supabase social provider for Apple and use a web-based OAuth flow.

import SwiftUI

// Centralized theme colors and helpers
enum AppTheme {
    static let teal = Color(red: 0.00, green: 0.58, blue: 0.53)
    static let orangeGlass = Color(red: 0.98, green: 0.65, blue: 0.20).opacity(0.85)
    static let cardBackground = Color(.systemBackground).opacity(0.95)

    static func accent() -> Color { teal }
}

extension Color {
    static var appTeal: Color { AppTheme.teal }
    static var appOrangeGlass: Color { AppTheme.orangeGlass }
    static var appCard: Color { AppTheme.cardBackground }
}

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.appCard)
            .cornerRadius(12)
            .shadow(color: Color.primary.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

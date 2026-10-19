import SwiftUI

struct EmptyStateView: View {
    var title: String
    var message: String
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.appOrangeGlass)
                    .frame(width: 80, height: 80)
                Image(systemName: "sparkles")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
            }

            Text(title)
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let action = action {
                Button(action: action) {
                    Text("Neue Aufgabe hinzufügen")
                        .bold()
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.appTeal))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(title: "Keine Aufgaben", message: "Füge deine erste Aufgabe hinzu.")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

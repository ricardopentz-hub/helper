import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            // Background image — make sure an asset named "background" exists in Assets.xcassets
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Optional overlay to improve foreground contrast
            Color.black.opacity(0.12)
                .ignoresSafeArea()

            TabView {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house.fill") }

                TasksView()
                    .tabItem { Label("Tasks", systemImage: "checkmark.square.fill") }

                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskStore())
}

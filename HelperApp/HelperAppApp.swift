import SwiftUI

@main
struct HelperAppApp: App {
    @StateObject private var store = TaskStore()
    @AppStorage("preferredColorScheme") private var preferredColorScheme: String = "system" // "system", "light", "dark"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .preferredColorScheme(preferredColorScheme == "light" ? .light : (preferredColorScheme == "dark" ? .dark : nil))
        }
    }
}

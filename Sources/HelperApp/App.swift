import SwiftUI

@main
struct HelperAppApp: App {
    @StateObject private var vm = NoteViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}

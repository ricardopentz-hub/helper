import SwiftUI

struct HelperAppApp: App {
    @StateObject private var vm = NoteViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}

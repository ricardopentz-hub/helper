import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: TaskStore
    @AppStorage("preferredColorScheme") private var preferredColorScheme: String = "system"
    @State private var showClearAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $preferredColorScheme) {
                        Text("System").tag("system")
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    .pickerStyle(.segmented)

                    Toggle("Compact UI (UI-only)", isOn: .constant(false))
                }

                Section(header: Text("App")) {
                    HStack {
                        Text("Bundle ID")
                        Spacer()
                        Text(Bundle.main.bundleIdentifier ?? "com.ricardopentz-hub.helper")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }

                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showClearAlert = true
                    } label: {
                        Text("Alle erledigten Aufgaben entfernen")
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Erledigte Aufgaben entfernen?", isPresented: $showClearAlert) {
                Button("Abbrechen", role: .cancel) {}
                Button("Entfernen", role: .destructive) { store.clearCompleted() }
            } message: {
                Text("Dies entfernt dauerhaft alle Aufgaben, die als erledigt markiert wurden.")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(TaskStore())
    }
}

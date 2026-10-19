import SwiftUI

// MARK: - Model
struct TaskItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var isDone: Bool = false
}

// MARK: - Store
final class TaskStore: ObservableObject {
    @Published var tasks: [TaskItem] = [] {
        didSet { save() }
    }

    private let key = "helper_tasks_v1"

    init() { load() }

    func add(_ title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        tasks.insert(TaskItem(title: trimmed), at: 0)
    }

    func toggle(_ task: TaskItem) {
        guard let idx = tasks.firstIndex(of: task) else { return }
        tasks[idx].isDone.toggle()
    }

    func remove(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    private func save() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([TaskItem].self, from: data) else {
            tasks = []
            return
        }
        tasks = decoded
    }
}

// MARK: - Views
struct ContentView: View {
    @StateObject private var store = TaskStore()

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            TasksView()
                .environmentObject(store)
                .tabItem {
                    Label("Tasks", systemImage: "checkmark.square.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

// Home: greeting + mini widget
struct HomeView: View {
    @State private var counter = 0
    private let tips = [
        "Tip: Swipe left on a task to delete it.",
        "Tip: Tap the checkbox to mark tasks done.",
        "Tip: Your tasks are stored locally on this device."
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to HelperApp")
                    .font(.largeTitle)
                    .bold()

                Text(tips.randomElement() ?? "Welcome!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    Text("Quick Counter")
                        .font(.headline)

                    HStack(spacing: 16) {
                        Button(action: { counter -= 1 }) {
                            Image(systemName: "minus.circle")
                                .font(.title)
                        }

                        Text("\(counter)")
                            .font(.title2)
                            .frame(minWidth: 60)

                        Button(action: { counter += 1 }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

// Tasks: add, toggle, delete, persist
struct TasksView: View {
    @EnvironmentObject var store: TaskStore
    @State private var newTaskText = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("New task…", text: $newTaskText)
                        .textFieldStyle(.roundedBorder)

                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .buttonStyle(.borderless)
                    .disabled(newTaskText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding([.horizontal, .top])

                List {
                    ForEach(store.tasks) { task in
                        TaskRow(task: task) {
                            store.toggle(task)
                        }
                    }
                    .onDelete(perform: store.remove)
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Tasks")
        }
    }

    private func addTask() {
        store.add(newTaskText)
        newTaskText = ""
    }
}

struct TaskRow: View {
    var task: TaskItem
    var toggleAction: () -> Void

    var body: some View {
        HStack {
            Button(action: toggleAction) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : .primary)
                    .imageScale(.large)
            }
            .buttonStyle(.plain)

            Text(task.title)
                .strikethrough(task.isDone, color: .secondary)
                .foregroundColor(task.isDone ? .secondary : .primary)

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

// Settings: basic info + toggles (UI-only)
struct SettingsView: View {
    @AppStorage("helper_compact_ui") private var compactUI = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Compact UI (UI-only)", isOn: $compactUI)
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
                    Text("This settings screen is UI-only. Configure signing, icons and more in Xcode.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

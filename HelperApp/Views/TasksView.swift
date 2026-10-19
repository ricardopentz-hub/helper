import SwiftUI

struct TasksView: View {
    @EnvironmentObject var store: TaskStore
    @State private var newTaskText = ""
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    TextField("New task…", text: $newTaskText)
                        .textFieldStyle(.roundedBorder)

                    Button(action: addTask) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.appTeal)
                    }
                    .disabled(newTaskText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()

                if store.tasks.isEmpty {
                    EmptyStateView(title: "Keine Aufgaben", message: "Füge deine erste Aufgabe hinzu.") {
                        // focus the text field: not available easily without Coordinator; keep simple
                    }
                    .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(store.tasks) { task in
                            TaskRowView(task: task) {
                                withAnimation { store.toggle(task) }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) { if let idx = store.tasks.firstIndex(of: task) { store.tasks.remove(at: idx) } } label: { Label("Delete", systemImage: "trash") }
                            }
                        }
                        .onMove(perform: store.move)
                        .onDelete(perform: store.remove)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .environment(\.editMode, $editMode)
        }
    }

    private func addTask() {
        store.add(newTaskText)
        newTaskText = ""
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView()
            .environmentObject(TaskStore())
    }
}

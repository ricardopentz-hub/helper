import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: TaskStore
    @State private var counter = 0
    private let tips = [
        "Wische nach links, um eine Aufgabe zu löschen.",
        "Tippe auf die Checkbox, um Aufgaben als erledigt zu markieren.",
        "Deine Aufgaben werden lokal gespeichert."
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome to HelperApp")
                            .font(.largeTitle).bold()

                        Text(tips.randomElement() ?? "Welcome!")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(LinearGradient(colors: [Color.appTeal.opacity(0.9), Color.appOrangeGlass.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(14)
                    .foregroundColor(.white)

                    HStack(spacing: 12) {
                        StatCard(title: "Open", value: "\(store.tasks.filter { !$0.isDone }.count)")
                        StatCard(title: "Done", value: "\(store.tasks.filter { $0.isDone }.count)")
                        StatCard(title: "Total", value: "\(store.tasks.count)")
                    }

                    VStack(spacing: 12) {
                        Text("Quick Counter")
                            .font(.headline)

                        HStack(spacing: 16) {
                            Button { counter -= 1 } label: {
                                Image(systemName: "minus.circle")
                                    .font(.title)
                            }

                            Text("\(counter)")
                                .font(.title2)
                                .frame(minWidth: 60)

                            Button { counter += 1 } label: {
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
            }
            .navigationTitle("Home")
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2).bold()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TaskStore())
    }
}

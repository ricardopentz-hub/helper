import SwiftUI

struct ContentView: View {
    @State private var counter = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Hello, HelperApp!")
                    .font(.title)
                    .padding()

                Text("Counter: \(counter)")
                    .font(.headline)

                HStack(spacing: 16) {
                    Button(action: { counter -= 1 }) {
                        Label("-", systemImage: "minus")
                            .font(.title2)
                    }
                    .buttonStyle(.bordered)

                    Button(action: { counter += 1 }) {
                        Label("+", systemImage: "plus")
                            .font(.title2)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("HelperApp")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

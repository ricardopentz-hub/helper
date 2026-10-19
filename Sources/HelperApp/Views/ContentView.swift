import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: NoteViewModel
    @State private var text: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $text)
                    .padding()
                    .frame(minHeight: 160)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))

                HStack {
                    Button(action: {
                        text = ""
                        viewModel.createBlankNote() // quick clear
                    }) {
                        Text("New")
                    }
                    Spacer()
                    Button(action: saveNote) {
                        Text("Save")
                    }
                }
                .padding()

                List {
                    ForEach(viewModel.notes) { note in
                        VStack(alignment: .leading) {
                            Text(note.content)
                                .lineLimit(3)
                                .foregroundColor(.primary)
                            Text(note.updatedAt.formatted())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Helper")
            .onAppear { viewModel.load() }
        }
    }

    private func saveNote() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        viewModel.save(content: trimmed)
        text = ""
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(NoteViewModel())
    }
}
#endif

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: NoteViewModel
    @State private var text: String = ""

    private let remoteBackgroundURL = URL(string: "https://raw.githubusercontent.com/ricardopentz-hub/helper/main/IMG_8488.heic")

    private var backgroundImage: some View {
        Group {
            if let remoteURL = remoteBackgroundURL {
                AsyncImage(url: remoteURL) { phase in
                    switch phase {
                    case .empty:
                        Color.clear
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        fallbackBackground
                    @unknown default:
                        fallbackBackground
                    }
                }
            } else {
                fallbackBackground
            }
        }
    }

    private var fallbackBackground: some View {
        Group {
            if let uiImage = UIImage(named: "IMG_8488") {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if let path = Bundle.main.path(forResource: "IMG_8488", ofType: "heic"),
                      let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Color(.systemBackground)
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                backgroundImage
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.35))

                VStack {
                    TextEditor(text: $text)
                        .padding()
                        .frame(minHeight: 160)
                        .background(Color(.systemBackground).opacity(0.55))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))

                    HStack {
                        Button(action: {
                            text = ""
                            viewModel.createBlankNote()
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
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                }
                .padding()
                .navigationTitle("Helper")
                .onAppear { viewModel.load() }
            }
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

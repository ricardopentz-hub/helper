import Foundation
import Combine

public class NoteViewModel: ObservableObject {
    @Published public private(set) var notes: [Note] = []

    private let storageKey = "helper.notes.v1"

    public init() {
        load()
    }

    public func createBlankNote() {
        // Convenience to add a blank note locally
        let n = Note(content: "")
        notes.insert(n, at: 0)
        saveToLocal()
    }

    public func save(content: String) {
        let note = Note(content: content, updatedAt: Date())
        notes.insert(note, at: 0)
        saveToLocal()
        // Placeholder: schedule push to backend (Supabase) when online
        // syncNoteToServer(note)
    }

    public func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            self.notes = decoded
        } else {
            self.notes = []
        }
    }

    private func saveToLocal() {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    // MARK: - Sync placeholders
    public func syncAll() {
        // TODO: push local changes to Supabase and pull remote updates
    }

    public func syncNoteToServer(_ note: Note) {
        // TODO: Implement a REST call to your Vercel function that upserts the note to Supabase.
    }
}

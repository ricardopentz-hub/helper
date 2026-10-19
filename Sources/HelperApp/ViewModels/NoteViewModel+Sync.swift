import Foundation

// Update NoteViewModel sync methods to call ApiClient

public extension NoteViewModel {
    func syncNoteToServer(_ note: Note, supabaseJWT: String, completion: ((Result<Void, Error>) -> Void)? = nil) {
        ApiClient.shared.upsertNote(note, supabaseJWT: supabaseJWT) { result in
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }

    func syncAll(supabaseJWT: String, completion: ((Result<Void, Error>) -> Void)? = nil) {
        // Push local notes
        let group = DispatchGroup()
        var lastError: Error?
        for note in notes {
            group.enter()
            syncNoteToServer(note, supabaseJWT: supabaseJWT) { res in
                if case .failure(let err) = res { lastError = err }
                group.leave()
            }
        }
        // Pull remote changes since latest updatedAt
        let latest = notes.first?.updatedAt
        group.notify(queue: .main) {
            ApiClient.shared.fetchNotes(since: latest, supabaseJWT: supabaseJWT) { res in
                switch res {
                case .success(let remoteNotes):
                    // Merge naive: replace local if remote has newer timestamps
                    var merged = self.notes
                    for r in remoteNotes {
                        if let idx = merged.firstIndex(where: { $0.id == r.id }) {
                            if r.updatedAt > merged[idx].updatedAt {
                                merged[idx] = r
                            }
                        } else {
                            merged.insert(r, at: 0)
                        }
                    }
                    self.notes = merged
                    self.saveToLocal()
                    completion?(.success(()))
                case .failure(let err):
                    completion?(.failure(err))
                }
            }
        }
    }
}

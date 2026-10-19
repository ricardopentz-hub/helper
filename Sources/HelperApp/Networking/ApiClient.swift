import Foundation

public final class ApiClient {
    public static let shared = ApiClient()
    private init() {}

    private var baseURL: URL {
        // Replace with your Vercel deployment URL for API endpoints
        return URL(string: "https://your-vercel-deployment.vercel.app/api")!
    }

    public func upsertNote(_ note: Note, supabaseJWT: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "notes", relativeTo: baseURL) else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(supabaseJWT)", forHTTPHeaderField: "Authorization")

        let payload: [String: Any] = [
            "id": note.id.uuidString,
            "content": note.content,
            "updated_at": ISO8601DateFormatter().string(from: note.updatedAt),
            "is_deleted": note.isDeleted
        ]

        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            completion(.failure(error)); return
        }

        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err { completion(.failure(err)); return }
            completion(.success(()))
        }.resume()
    }

    public func fetchNotes(since: Date?, supabaseJWT: String, completion: @escaping (Result<[Note], Error>) -> Void) {
        var components = URLComponents(url: baseURL.appendingPathComponent("notes"), resolvingAgainstBaseURL: true)!
        if let since = since {
            components.queryItems = [URLQueryItem(name: "since", value: ISO8601DateFormatter().string(from: since))]
        }
        guard let url = components.url else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("Bearer \(supabaseJWT)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err { completion(.failure(err)); return }
            guard let data = data else { completion(.success([])); return }
            do {
                let wrapper = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let arr = wrapper?["data"] as? [[String: Any]] ?? []
                let notes: [Note] = arr.compactMap { dict in
                    guard let idStr = dict["id"] as? String, let id = UUID(uuidString: idStr), let content = dict["content"] as? String, let updatedAtStr = dict["updated_at"] as? String, let updatedAt = ISO8601DateFormatter().date(from: updatedAtStr) else { return nil }
                    return Note(id: id, content: content, updatedAt: updatedAt, isDeleted: (dict["is_deleted"] as? Bool) ?? false)
                }
                completion(.success(notes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

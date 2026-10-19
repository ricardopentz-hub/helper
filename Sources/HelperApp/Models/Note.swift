import Foundation
import Combine

public struct Note: Identifiable, Codable, Equatable {
    public let id: UUID
    public var content: String
    public var updatedAt: Date
    public var isDeleted: Bool

    public init(id: UUID = UUID(), content: String, updatedAt: Date = Date(), isDeleted: Bool = false) {
        self.id = id
        self.content = content
        self.updatedAt = updatedAt
        self.isDeleted = isDeleted
    }
}

import Foundation
import CloudKit

struct CloudTaskRecordKeys {
    static let type = "TaskItem"
    static let title = "title"
    static let isDone = "isDone"
    static let createdAt = "createdAt"
    static let updatedAt = "updatedAt"
}

final class CloudTaskStore: ObservableObject {
    @Published var tasks: [TaskItem] = []

    private let privateDatabase: CKDatabase
    private let localKey = "helper_tasks_v1"
    private let lastSyncKey = "helper_last_sync_v1"
    private let container: CKContainer
    private var hasLoaded = false

    init(containerIdentifier: String = "iCloud.com.ricardopentz-hub.helper") {
        self.container = CKContainer(identifier: containerIdentifier)
        self.privateDatabase = container.privateCloudDatabase
        loadLocalTasks()
        requestAuthorizationAndFetch()
    }

    func add(_ title: String) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let task = TaskItem(title: trimmed)
        tasks.insert(task, at: 0)
        saveLocal()
        saveToCloud(task)
    }

    func toggle(_ task: TaskItem) {
        guard let idx = tasks.firstIndex(of: task) else { return }
        var updated = task
        updated.isDone.toggle()
        tasks[idx] = updated
        saveLocal()
        saveToCloud(updated)
    }

    func remove(at offsets: IndexSet) {
        let removed = offsets.compactMap { tasks.indices.contains($0) ? tasks[$0] : nil }
        tasks.remove(atOffsets: offsets)
        saveLocal()
        removed.forEach { deleteFromCloud($0) }
    }

    func move(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        saveLocal()
        syncLocalToCloud()
    }

    func clearCompleted() {
        let removed = tasks.filter { $0.isDone }
        tasks.removeAll { $0.isDone }
        saveLocal()
        removed.forEach { deleteFromCloud($0) }
    }

    private func loadLocalTasks() {
        guard let data = UserDefaults.standard.data(forKey: localKey),
              let decoded = try? JSONDecoder().decode([TaskItem].self, from: data) else {
            tasks = []
            return
        }
        tasks = decoded
    }

    private func saveLocal() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: localKey)
        }
    }

    private func requestAuthorizationAndFetch() {
        container.accountStatus { [weak self] status, _ in
            guard let self else { return }
            switch status {
            case .available:
                self.fetchCloudTasks()
            default:
                self.hasLoaded = true
                self.syncLocalToCloudIfNeeded()
            }
        }
    }

    private func syncLocalToCloudIfNeeded() {
        guard hasLoaded else { return }
        if tasks.isEmpty { return }
        let existing = tasks
        existing.forEach { saveToCloud($0) }
    }

    private func fetchCloudTasks() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: CloudTaskRecordKeys.type, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: CloudTaskRecordKeys.updatedAt, ascending: false)]

        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 500
        operation.recordFetchedBlock = { [weak self] record in
            guard let self else { return }
            guard let task = self.task(from: record) else { return }
            if !self.tasks.contains(task) {
                self.tasks.append(task)
            }
        }

        operation.queryCompletionBlock = { [weak self] _, error in
            DispatchQueue.main.async {
                self?.hasLoaded = true
                if let error {
                    print("Cloud fetch failed: \(error.localizedDescription)")
                }
                self?.saveLocal()
                self?.syncLocalToCloudIfNeeded()
            }
        }

        privateDatabase.add(operation)
    }

    private func saveToCloud(_ task: TaskItem) {
        let recordID = CKRecord.ID(recordName: task.id.uuidString)
        let record = CKRecord(recordType: CloudTaskRecordKeys.type, recordID: recordID)
        record[CloudTaskRecordKeys.title] = task.title as CKRecordValue
        record[CloudTaskRecordKeys.isDone] = task.isDone as CKRecordValue
        record[CloudTaskRecordKeys.createdAt] = Date() as CKRecordValue
        record[CloudTaskRecordKeys.updatedAt] = Date() as CKRecordValue

        let saveOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: [])
        saveOperation.savePolicy = .changedKeys
        saveOperation.qualityOfService = .userInitiated
        saveOperation.modifyRecordsCompletionBlock = { _, _, error in
            if let error {
                print("Cloud save failed: \(error.localizedDescription)")
            }
        }
        privateDatabase.add(saveOperation)
    }

    private func deleteFromCloud(_ task: TaskItem) {
        let recordID = CKRecord.ID(recordName: task.id.uuidString)
        let operation = CKModifyRecordsOperation(recordsToSave: [], recordIDsToDelete: [recordID])
        operation.qualityOfService = .userInitiated
        operation.modifyRecordsCompletionBlock = { _, _, error in
            if let error {
                print("Cloud delete failed: \(error.localizedDescription)")
            }
        }
        privateDatabase.add(operation)
    }

    private func task(from record: CKRecord) -> TaskItem? {
        guard let title = record[CloudTaskRecordKeys.title] as? String,
              let isDone = record[CloudTaskRecordKeys.isDone] as? Bool else { return nil }

        return TaskItem(id: UUID(uuidString: record.recordID.recordName) ?? UUID(), title: title, isDone: isDone)
    }

    private func syncLocalToCloud() {
        tasks.forEach { saveToCloud($0) }
    }
}

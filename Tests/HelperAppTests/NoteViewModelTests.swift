import XCTest
@testable import HelperApp

final class NoteViewModelTests: XCTestCase {
    private let storageKey = "helper.notes.v1"

    override func setUp() {
        super.setUp()
        // Ensure a clean state before each test
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    override func tearDown() {
        // Clean up after each test
        UserDefaults.standard.removeObject(forKey: storageKey)
        super.tearDown()
    }

    func testSaveAndLoadNote() {
        let vm = NoteViewModel()

        XCTAssertTrue(vm.notes.isEmpty)

        vm.save(content: "Hello world")
        XCTAssertEqual(vm.notes.count, 1)
        XCTAssertEqual(vm.notes.first?.content, "Hello world")

        // create new instance and load from UserDefaults
        let vm2 = NoteViewModel()
        vm2.load()
        XCTAssertEqual(vm2.notes.count, 1)
        XCTAssertEqual(vm2.notes.first?.content, "Hello world")
    }

    func testCreateBlankNoteAddsEmptyNoteToFront() {
        let vm = NoteViewModel()

        vm.createBlankNote()

        XCTAssertEqual(vm.notes.count, 1)
        XCTAssertEqual(vm.notes.first?.content, "")
        XCTAssertEqual(vm.notes.first?.isDeleted, false)
    }

    func testSaveInsertsNewestNoteAtIndexZero() {
        let vm = NoteViewModel()

        vm.save(content: "First")
        vm.save(content: "Second")

        XCTAssertEqual(vm.notes.count, 2)
        XCTAssertEqual(vm.notes[0].content, "Second")
        XCTAssertEqual(vm.notes[1].content, "First")
    }

    func testLoadRestoresPreviouslySavedNotes() {
        let expectedNotes = [
            Note(content: "First note"),
            Note(content: "Second note")
        ]

        let data = try! JSONEncoder().encode(expectedNotes)
        UserDefaults.standard.set(data, forKey: storageKey)

        let vm = NoteViewModel()

        XCTAssertEqual(vm.notes, expectedNotes)
    }

    func testSaveCreatesNoteWithDefaultIsDeletedFalse() {
        let vm = NoteViewModel()

        vm.save(content: "Keep me")

        XCTAssertEqual(vm.notes.count, 1)
        let note = vm.notes.first!
        XCTAssertEqual(note.content, "Keep me")
        XCTAssertFalse(note.isDeleted)
    }
}

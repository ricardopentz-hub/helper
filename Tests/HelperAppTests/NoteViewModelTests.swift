import XCTest
@testable import HelperApp

final class NoteViewModelTests: XCTestCase {
    func testSaveAndLoadNote() {
        let vm = NoteViewModel()
        // clear any existing
        UserDefaults.standard.removeObject(forKey: "helper.notes.v1")

        XCTAssertTrue(vm.notes.isEmpty)

        vm.save(content: "Hello world")
        XCTAssertEqual(vm.notes.count, 1)
        XCTAssertEqual(vm.notes.first?.content, "Hello world")

        // create new instance and load
        let vm2 = NoteViewModel()
        vm2.load()
        XCTAssertEqual(vm2.notes.count, 1)
        XCTAssertEqual(vm2.notes.first?.content, "Hello world")
    }
}

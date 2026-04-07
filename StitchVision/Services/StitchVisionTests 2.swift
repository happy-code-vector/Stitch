import XCTest
@testable import StitchVision

// MARK: - KeychainManager Tests

final class KeychainManagerTests: XCTestCase {

    private let testKey = "com.stitchvision.test.keychain.key"

    override func tearDown() {
        super.tearDown()
        // Always clean up the test key so tests don't bleed into each other
        KeychainManager.delete(forKey: testKey)
    }

    func test_roundTrip() {
        let value = "super-secret-api-key-12345"
        XCTAssertTrue(KeychainManager.set(value, forKey: testKey))
        XCTAssertEqual(KeychainManager.get(forKey: testKey), value)
    }

    func test_unknownKey_returnsNil() {
        XCTAssertNil(KeychainManager.get(forKey: "this-key-does-not-exist"))
    }

    func test_overwrite() {
        KeychainManager.set("first", forKey: testKey)
        KeychainManager.set("second", forKey: testKey)
        XCTAssertEqual(KeychainManager.get(forKey: testKey), "second")
    }

    func test_delete_removesValue() {
        KeychainManager.set("to-delete", forKey: testKey)
        XCTAssertTrue(KeychainManager.delete(forKey: testKey))
        XCTAssertNil(KeychainManager.get(forKey: testKey))
    }

    func test_delete_isIdempotentForMissingKey() {
        // Must not crash or return false just because the item is absent
        XCTAssertTrue(KeychainManager.delete(forKey: "never-stored"))
    }

    func test_setNil_deletesKey() {
        KeychainManager.set("exists", forKey: testKey)
        KeychainManager.set(nil, forKey: testKey)
        XCTAssertNil(KeychainManager.get(forKey: testKey))
    }
}

// MARK: - DatabaseError Tests

final class DatabaseErrorTests: XCTestCase {

    func test_prepareFailed_carriesMessage() {
        let error = DatabaseError.prepareFailed("no such table: foo")
        XCTAssertTrue(error.errorDescription?.contains("no such table: foo") == true)
    }

    func test_executionFailed_carriesMessage() {
        let error = DatabaseError.executionFailed("UNIQUE constraint failed")
        XCTAssertTrue(error.errorDescription?.contains("UNIQUE constraint failed") == true)
    }

    func test_connectionFailed_hasReadableDescription() {
        let desc = DatabaseError.connectionFailed.errorDescription ?? ""
        XCTAssertFalse(desc.isEmpty)
    }

    func test_notFound_hasReadableDescription() {
        let desc = DatabaseError.notFound.errorDescription ?? ""
        XCTAssertFalse(desc.isEmpty)
    }
}

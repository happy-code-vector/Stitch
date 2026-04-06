import Testing
import Foundation
@testable import StitchVision

// MARK: - KeychainManager Tests

@Suite("KeychainManager")
struct KeychainManagerTests {

    private let testKey = "com.stitchvision.test.keychain.key"

    @Test("Round-trips a string value")
    func roundTrip() throws {
        let value = "super-secret-api-key-12345"

        #expect(KeychainManager.set(value, forKey: testKey))
        #expect(KeychainManager.get(forKey: testKey) == value)

        // Clean up
        KeychainManager.delete(forKey: testKey)
    }

    @Test("Returns nil for unknown key")
    func unknownKey() {
        #expect(KeychainManager.get(forKey: "this-key-does-not-exist") == nil)
    }

    @Test("Overwrites an existing value")
    func overwrite() throws {
        KeychainManager.set("first", forKey: testKey)
        KeychainManager.set("second", forKey: testKey)

        #expect(KeychainManager.get(forKey: testKey) == "second")

        KeychainManager.delete(forKey: testKey)
    }

    @Test("Delete returns true and removes the value")
    func deletion() throws {
        KeychainManager.set("to-delete", forKey: testKey)
        #expect(KeychainManager.delete(forKey: testKey))
        #expect(KeychainManager.get(forKey: testKey) == nil)
    }

    @Test("Delete is idempotent for missing keys")
    func deleteNonExistent() {
        // Should not crash or return false just because the item is absent
        #expect(KeychainManager.delete(forKey: "never-stored"))
    }

    @Test("Setting nil deletes the key")
    func setNilDeletes() throws {
        KeychainManager.set("exists", forKey: testKey)
        KeychainManager.set(nil, forKey: testKey)
        #expect(KeychainManager.get(forKey: testKey) == nil)
    }
}

// MARK: - DatabaseError Tests

@Suite("DatabaseError")
struct DatabaseErrorTests {

    @Test("prepareFailed carries the message")
    func prepareFailedMessage() {
        let error = DatabaseError.prepareFailed("no such table: foo")
        #expect(error.errorDescription?.contains("no such table: foo") == true)
    }

    @Test("executionFailed carries the message")
    func executionFailedMessage() {
        let error = DatabaseError.executionFailed("UNIQUE constraint failed")
        #expect(error.errorDescription?.contains("UNIQUE constraint failed") == true)
    }

    @Test("connectionFailed has a user-readable description")
    func connectionFailedDescription() {
        let error = DatabaseError.connectionFailed
        let desc = error.errorDescription ?? ""
        #expect(!desc.isEmpty)
    }

    @Test("notFound has a user-readable description")
    func notFoundDescription() {
        let error = DatabaseError.notFound
        let desc = error.errorDescription ?? ""
        #expect(!desc.isEmpty)
    }
}

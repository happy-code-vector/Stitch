import Foundation
import Security

/// A minimal, focused Keychain wrapper for storing sensitive string credentials.
/// Use this instead of `UserDefaults` for any API keys or tokens.
enum KeychainManager {

    private static let service = Bundle.main.bundleIdentifier ?? "com.stitchvision.app"

    // MARK: - Public API

    /// Save or update a string value in the Keychain.
    /// - Parameters:
    ///   - value: The string to store. Pass `nil` to delete the item.
    ///   - key: A stable identifier for this credential.
    @discardableResult
    static func set(_ value: String?, forKey key: String) -> Bool {
        guard let value else {
            return delete(forKey: key)
        }
        guard let data = value.data(using: .utf8) else { return false }

        var query = baseQuery(forKey: key)

        // If item already exists, update it.
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        if status == errSecSuccess {
            let attributes: [CFString: Any] = [kSecValueData: data]
            return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
        }

        // Otherwise insert a new item.
        query[kSecValueData] = data
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }

    /// Read a string value from the Keychain.
    /// - Parameter key: The identifier used when the value was stored.
    /// - Returns: The stored string, or `nil` if not found.
    static func get(forKey key: String) -> String? {
        var query = baseQuery(forKey: key)
        query[kSecMatchLimit]       = kSecMatchLimitOne
        query[kSecReturnData]       = true
        query[kSecReturnAttributes] = true

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let dict = result as? [CFString: Any],
              let data = dict[kSecValueData] as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// Delete a value from the Keychain.
    @discardableResult
    static func delete(forKey key: String) -> Bool {
        let query = baseQuery(forKey: key)
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    // MARK: - Private Helpers

    private static func baseQuery(forKey key: String) -> [CFString: Any] {
        [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
        ]
    }
}

// MARK: - Well-Known Keys

extension KeychainManager {
    enum Keys {
        static let geminiAPIKey = "geminiApiKey"
    }
}

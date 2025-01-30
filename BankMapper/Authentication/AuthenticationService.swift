//
//  AuthenticationService.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/23/25.
//

import Security
import Foundation

class AuthenticationService {
    static let shared = AuthenticationService()
    private init() {}
    
    /// Adds new credentials to Keychain. Fails if the item already exists.
    func addCredentials(username: String, password: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: passwordData
        ]
        
        // Try to add the item
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Updates existing credentials in Keychain. Fails if the item does not exist.
    func updateCredentials(username: String, password: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username
        ]
        
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: passwordData
        ]
        
        // Try to update the item
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        return status == errSecSuccess
    }
    
    /// Saves credentials by either adding or updating them.
    func saveCredentials(username: String, password: String) -> Bool {
        // First, try to update the credentials if they already exist
        if updateCredentials(username: username, password: password) {
            return true
        }
        
        // If updating failed, try to add them as new credentials
        return addCredentials(username: username, password: password)
    }
    
    /// Retrieves credentials for a given username.
    func getCredentials(username: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// Deletes credentials for a given username.
    func deleteCredentials(username: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

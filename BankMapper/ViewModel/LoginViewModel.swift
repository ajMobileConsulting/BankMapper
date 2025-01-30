//
//  LoginViewModel.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import SwiftUI
import Combine
import Security

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoginSuccessful: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func login() {
        errorMessage = nil
//        AuthenticationService.shared.saveCredentials(username: $username, password: $password)

        guard !username.isEmpty else {
            errorMessage = "Username cannot be empty"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return
        }
        
        // Validate username and password using Keychain
        if let storedPassword = getPassword(for: username), storedPassword == password {
            DispatchQueue.main.async { [weak self] in
                self?.isLoginSuccessful = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.errorMessage = "Invalid username or password"
            }
        }
    }
    
    func registerNewUser() {
        errorMessage = nil

        guard !username.isEmpty else {
            errorMessage = "Username cannot be empty"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return
        }
        
        // Save the username and password in Keychain
        let success = savePassword(password, for: username)
        if success {
            DispatchQueue.main.async { [weak self] in
                self?.isLoginSuccessful = true
            }
        } else {
            errorMessage = "Failed to save user credentials"
        }
    }
    
    func logout() {
        // Remove credentials from Keychain
        let success = deletePassword(for: username)
        if success {
            DispatchQueue.main.async { [weak self] in
                self?.isLoginSuccessful = false
                self?.username = ""
                self?.password = ""
            }
        } else {
            errorMessage = "Failed to log out"
        }
    }
    
    // MARK: - Keychain Helper Methods
    
    private func savePassword(_ password: String, for username: String) -> Bool {
        // Convert password to Data
        guard let passwordData = password.data(using: .utf8) else { return false }
        
        // Prepare Keychain Query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: passwordData
        ]
        
        // Delete any existing item for the username
        SecItemDelete(query as CFDictionary)
        
        // Add new Keychain entry
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    private func getPassword(for username: String) -> String? {
        // Prepare Keychain Query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        // Check if the query was successful
        guard status == errSecSuccess, let passwordData = dataTypeRef as? Data else { return nil }
        return String(data: passwordData, encoding: .utf8)
    }
    
    private func deletePassword(for username: String) -> Bool {
        // Prepare Keychain Query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

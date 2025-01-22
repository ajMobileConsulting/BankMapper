//
//  LoginViewModel.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoginSuccessful: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func login() {
        errorMessage = nil
        
        guard !username.isEmpty else {
            errorMessage = "Username cannot be empty"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return
        }
        
        if username == "test" && password == "abc123" {
            DispatchQueue
                .main
                .async { [weak self] in
                    guard let self else { return }
                    self.isLoginSuccessful = true
                
            }
        } else {
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 1) { [weak self] in
                    guard let self else { return }
                    self.errorMessage = "Login failed"
                
            }
        }
    }
}

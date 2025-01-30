//
//  LoginView.swift
//  BankMapper
//
//  Created by Alexander Jackson on 1/21/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    let dismissAction: () -> () // To handle dismissal
    
    var body: some View {
        
        BackNavigable(title: "User Login", dismissAction: {
            dismissAction()
        }, content: {
            VStack(spacing: 20) {
                // Username Field
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                // Password Field
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                Button("Login") {
                    viewModel.login()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                
                Button("Register") {
                    viewModel.registerNewUser()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                
                Button("Logout") {
                    viewModel.logout()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
                
                Spacer()
            }
        })
    }
}

#Preview {
    LoginView() {
        print("dismiss")
    }
}

//
//  LoginView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-03-14.
//
import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var savedUsername: String
    @Binding var savedPassword: String
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showUserTypeSelectionView: Bool = false
    @State private var showLoginErrorAlert: Bool = false // Track login errors
    @State private var isUsernameValid: Bool = true
    @State private var isPasswordValid: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.green
                    .ignoresSafeArea() // Ensure the green background covers the entire screen
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                VStack(spacing: 20) {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isUsernameValid ? Color.clear : Color.red, lineWidth: 1)
                        )

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isPasswordValid ? Color.clear : Color.red, lineWidth: 1)
                        )

                    // Update the login button logic
                    Button(action: {
                        isUsernameValid = username == savedUsername
                        isPasswordValid = password == savedPassword
                        
                        if isUsernameValid && isPasswordValid {
                            isLoggedIn = true
                        } else {
                            showLoginErrorAlert = true
                        }
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .alert(isPresented: $showLoginErrorAlert) {
                        Alert(
                            title: Text("Login Failed"),
                            message: Text("Incorrect username or password. Please try again."),
                            dismissButton: .default(Text("OK"))
                    )}
                    
                    Button(action: {
                        showUserTypeSelectionView = true
                    }) {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Login")
            .background(
                NavigationLink(
                    destination: UserTypeSelectionView(isShowingCreateAccount: $showUserTypeSelectionView, savedUsername: $savedUsername, savedPassword: $savedPassword),
                    isActive: $showUserTypeSelectionView
                ) { EmptyView() }
            )
        }
        .navigationBarHidden(true)
    }
}

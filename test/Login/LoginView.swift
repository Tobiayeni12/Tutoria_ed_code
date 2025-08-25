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
    @State private var showLoginErrorAlert: Bool = false
    @State private var isUsernameValid: Bool = true
    @State private var isPasswordValid: Bool = true

    @FocusState private var focusedField: Field?
    private enum Field { case username, password }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.35).foregroundColor(.white)

                VStack(spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Login")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                        Text("Welcome!")
                            .font(.title3)
                            .fontWeight(.semibold)          // ✅ use fontWeight
                            .foregroundColor(Color.black.opacity(0.75)) // ✅ explicit Color.black
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                    // Username
                    StyledTextField(
                        text: $username,
                        placeholder: "Username",
                        isInvalid: !isUsernameValid,
                        isSecure: false
                    )
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }

                    // Password
                    StyledTextField(
                        text: $password,
                        placeholder: "Password",
                        isInvalid: !isPasswordValid,
                        isSecure: true
                    )
                    .focused($focusedField, equals: .password)
                    .submitLabel(.done)
                    .onSubmit { focusedField = nil }

                    // Login
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
                            .foregroundColor(Color.black)
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
                        )
                    }

                    // Create Account
                    Button(action: { showUserTypeSelectionView = true }) {
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
                .padding(.bottom)
            }
            .background(
                NavigationLink(
                    destination: UserTypeSelectionView(
                        isShowingCreateAccount: $showUserTypeSelectionView,
                        savedUsername: $savedUsername,
                        savedPassword: $savedPassword
                    ),
                    isActive: $showUserTypeSelectionView
                ) { EmptyView() }
            )
            .contentShape(Rectangle())
            .onTapGesture { focusedField = nil }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

private struct StyledTextField: View {
    @Binding var text: String
    let placeholder: String
    let isInvalid: Bool
    let isSecure: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.black.opacity(0.35))
                    .padding(.horizontal, 16)
            }

            Group {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
            }
            .foregroundColor(Color.black)
            .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 2, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}


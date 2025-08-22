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

    // Focus handling so we can dismiss keyboard on screen tap
    @FocusState private var focusedField: Field?
    private enum Field { case username, password }

    var body: some View {
        NavigationView {
            ZStack {
                Color.green.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.35).foregroundColor(.white)

                VStack(spacing: 20) {
                    Text("Welcome!")
                        .font(.largeTitle).fontWeight(.bold)

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
                .padding()
            }
            .navigationTitle("Login")
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
            // Dismiss keyboard when tapping anywhere outside the fields
            .contentShape(Rectangle())
            .onTapGesture { focusedField = nil }
            // Add a toolbar “Done” button above the keyboard as well
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

/// A reusable text field with a bright placeholder and consistent styling
private struct StyledTextField: View {
    @Binding var text: String
    let placeholder: String
    let isInvalid: Bool
    let isSecure: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            // Custom placeholder with stronger contrast
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.black.opacity(0.35))   // <— more visible
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
            .foregroundColor(.black) // entered text color
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

//
//  CreateAccountView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//

import SwiftUI

struct CreateAccountView: View {
    @AppStorage("studentDetails") private var storedStudentDetails: String = ""
    @Binding var savedUsername: String
    @Binding var savedPassword: String
    @Binding var isShowingCreateAccount: Bool
    
    @State private var newUsername: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    var userType: String // "Student" or "Teacher"
    var studentDetails: StudentDetails? // Optional student details
    
    var body: some View {
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
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("User Type: \(userType)") // Display the selected user type
                    .font(.headline)
                    .foregroundColor(.black)
                
                TextField("New Username", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                SecureField("New Password", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Password requirements text
                Text("Password must be 8-12 characters and contain at least 1 digit and 1 special character.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    if newUsername.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty {
                        alertMessage = "Please fill in all fields."
                        showAlert = true
                    } else if newPassword != confirmPassword {
                        alertMessage = "Passwords do not match."
                        showAlert = true
                    } else if !isPasswordValid(newPassword) {
                        alertMessage = "Password must be 8-12 characters long, contain at least 1 digit, and 1 special character."
                        showAlert = true
                    } else {
                        savedUsername = newUsername
                        savedPassword = newPassword

                        if let studentDetails = studentDetails {
                            if let encoded = try? JSONEncoder().encode(studentDetails) {
                                UserDefaults.standard.set(encoded, forKey: "studentDetails")
                            }
                        }

                        alertMessage = "Account created successfully!"
                        showAlert = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isShowingCreateAccount = false
                        }
                    }
                }) {
                    Text("Create Account")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }

                .padding(.horizontal)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Message"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Create Account")
        .navigationBarHidden(true)
    }
    
    // Password validation function
    func isPasswordValid(_ password: String) -> Bool {
        // Check password length (8-12 characters)
        guard password.count >= 8 && password.count <= 12 else {
            return false
        }
        
        // Check for at least 1 digit
        let digitRegex = ".*[0-9]+.*"
        let digitPredicate = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        guard digitPredicate.evaluate(with: password) else {
            return false
        }
        
        // Check for at least 1 special character
        let specialCharacterRegex = ".*[!@#$%^&*()]+.*"
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        guard specialCharacterPredicate.evaluate(with: password) else {
            return false
        }
        
        return true
    }
}

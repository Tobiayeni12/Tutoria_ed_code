//
//  UserTypeSelectionView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-03-14.
//

import SwiftUI

struct UserTypeSelectionView: View {
    @Binding var isShowingCreateAccount: Bool
    @Binding var savedUsername: String
    @Binding var savedPassword: String
    
    @State private var selectedUserType: String? = nil // Track the selected user type
    
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
                Text("Are you a...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Button(action: {
                    selectedUserType = "Student" // Set user type to Student
                }) {
                    Text("Student")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                
                Button(action: {
                    selectedUserType = "Teacher" // Set user type to Teacher
                }) {
                    Text("Teacher")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Select User Type")
        .navigationBarHidden(true)
        .background(
            NavigationLink(
                destination: selectedUserType == "Student" ?
                    AnyView(StudentRegistrationView(
                        savedUsername: $savedUsername,
                        savedPassword: $savedPassword,
                        isShowingCreateAccount: $isShowingCreateAccount
                    )) :
                    AnyView(CreateAccountView(
                        savedUsername: $savedUsername,
                        savedPassword: $savedPassword,
                        isShowingCreateAccount: $isShowingCreateAccount,
                        userType: selectedUserType ?? ""
                    )),
                isActive: Binding<Bool>(
                    get: { selectedUserType != nil },
                    set: { _ in selectedUserType = nil } // Reset after navigation
                )
            ) { EmptyView() }
        )
    }
}

//
//  ProfileView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//

import SwiftUI

struct ProfileView: View {
    var studentDetails: StudentDetails

    @State private var isShowingSettings = false
    @State private var isShowingHelp = false
    @State private var isShowingAbout = false
    @State private var isShowingWallet = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 60)

                    // Profile Title
                    HStack {
                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                        Spacer()
                    }

                    // User Details Bubble
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Circle()
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .padding(20)
                                )
                                .background(Color.green)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 10) {
                                Text("Full Name: \(studentDetails.fullName)")
                                Text("Level of Education: \(studentDetails.levelOfEducation)")
                                if studentDetails.levelOfEducation == "University" {
                                    Text("University: \(studentDetails.universityName)")
                                    Text("Year of Study: \(studentDetails.yearOfStudy)")
                                    Text("Major: \(studentDetails.major)")
                                } else {
                                    Text("High School: \(studentDetails.highSchoolName)")
                                }
                            }
                            .padding(.leading, 10)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    .padding(.horizontal, 20)

                    // Second Bubble (Placeholder)
                    Text("Second Bubble Section")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                        .padding(.horizontal, 20)

                    // Third Bubble (Navigation Buttons)
                    VStack(spacing: 0) {
                        Button(action: { isShowingSettings = true }) {
                            Text("Settings")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .foregroundColor(.green)
                        }
                        Divider()

                        Button(action: { isShowingHelp = true }) {
                            Text("Help")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        Divider()

                        Button(action: { isShowingAbout = true }) {
                            Text("About")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        Divider()

                        Button(action: { isShowingWallet = true }) {
                            Text("Wallet")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }

                        // Navigation Links with state binding
                        NavigationLink(destination: SettingsView(isActive: $isShowingSettings), isActive: $isShowingSettings) { EmptyView() }
                        NavigationLink(destination: HelpView(), isActive: $isShowingHelp) { EmptyView() }
                        NavigationLink(destination: AboutView(), isActive: $isShowingAbout) { EmptyView() }
                        NavigationLink(destination: WalletView(), isActive: $isShowingWallet) { EmptyView() }
                    }
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}



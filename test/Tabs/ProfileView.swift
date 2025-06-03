//
//  ProfileView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//

import SwiftUI

struct ProfileView: View {
    var studentDetails: StudentDetails

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Add padding to push content below the safe area
                    Spacer().frame(height: 60) // Adjust this height if needed

                    // Profile Title (Aligned to the left)
                    HStack {
                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading, 20) // Align with the left edge of the bubbles
                        Spacer() // Push the title to the left
                    }

                    // First Bubble (User Details)
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
                            .padding(.leading, 10) // Add some spacing between the image and text
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3) // Added shadow
                    .padding(.horizontal, 20) // Add horizontal padding to align with the title

                    // Second Bubble (Placeholder)
                    Text("Second Bubble Section")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading) // Align to the left
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3) // Added shadow
                        .padding(.horizontal, 20) // Add horizontal padding to align with the title

                    // Third Bubble (List of Options)
                    VStack(spacing: 0) {
                        NavigationLink(destination: SettingsView()) {
                            Text("Settings")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .foregroundColor(.green)
                        }
                        Divider()
                        
                        NavigationLink(destination: HelpView()) {
                            Text("Help")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        Divider()
                        
                        NavigationLink(destination: AboutView()) {
                            Text("About")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        Divider()
                        
                        NavigationLink(destination: WalletView()) {
                            Text("Wallet")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                    }
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3) // Added shadow
                    .padding(.horizontal, 20) // Add horizontal padding to align with the title

                    Spacer() // Push everything to the top
                }
            }
        }
        .navigationTitle("") // Hide the default navigation title
    }
}

//
//  SettingsView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//
import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                // Custom Navigation Bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.green)
                        .padding(.top, 50) // Adjust this value to move the button below the safe area
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .background(Color.white) // Ensure the background matches the view

                // Content
                Text("Settings Page")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.top, 20) // Add some padding to separate from the navigation bar
                Spacer()
            }
        }
        .navigationTitle("") // Hide the default navigation title
        .navigationBarHidden(true) // Hide the default navigation bar
    }
}

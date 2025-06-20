//
//  SettingsView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//
import SwiftUI

struct SettingsView: View {
    @Binding var isActive: Bool

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                // Custom Back Button
                HStack {
                    Button(action: {
                        isActive = false // Properly dismiss and reset navigation
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.green)
                        .padding(.top, 50)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .background(Color.white)

                // Content
                Text("Settings Page")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

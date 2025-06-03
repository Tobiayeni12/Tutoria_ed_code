//
//  FirstView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//
import SwiftUI  

struct FirstView: View {
    var body: some View {
        ZStack {
            Image("usask blurred")
                .resizable()
                .scaledToFill() // Fill the entire screen
                .edgesIgnoringSafeArea(.all) // Ignore safe area to cover the whole screen
            
            VStack {
                Text("Coming September 2025.")
                    .font(.title)
                    .fontWeight(.bold)
                    .shadow(radius: 1)
                
                Text("Your all-in-one university sidekick")
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(radius: 1)
            }
        }
    }
}

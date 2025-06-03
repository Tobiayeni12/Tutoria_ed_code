//
//  AboutView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("About Page")
                .font(.title)
                .foregroundColor(.black)
        }
        .navigationTitle("About") // Shows the title with back button
        .navigationBarTitleDisplayMode(.inline)
    }
}

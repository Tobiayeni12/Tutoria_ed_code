//
//  WalletView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//

import SwiftUI

struct WalletView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("Wallet Page")
                .font(.title)
                .foregroundColor(.black)
        }
        .navigationTitle("Wallet") // Shows the title with back button
        .navigationBarTitleDisplayMode(.inline)
    }
}

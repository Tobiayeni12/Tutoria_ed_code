//
//  SecondView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//

import SwiftUI

// MARK: - Listing Model
struct Listing: Identifiable {
    let id = UUID()
    let title: String
    let price: Double
    let imageName: String
}

// Temporary sample listings (leave empty for now)
let sampleListings: [Listing] = [
//    Listing(title: "Biology 120 Textbook", price: 45.00, imageName: "bioBook"),
//    Listing(title: "Graphing Calculator", price: 60.00, imageName: "calculator")
]

// MARK: - Main Marketplace View
struct SecondView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var showingNewListingView = false

    var body: some View {
        NavigationView {
            if sampleListings.isEmpty {
                // Empty state view
                VStack {
                    Image(systemName: "tray.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding(.top, 60)

                    Text("No Listings Yet")
                        .font(.title2)
                        .padding(.top)

                    Text("Be the first to post a listing and help your classmates!")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding()

                    Button(action: {
                        showingNewListingView = true
                    }) {
                        Text("Post Your First Listing")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showingNewListingView) {
                        NewListingView()
                    }
                }
                .padding()
                .navigationTitle("Marketplace")
            } else {
                // Grid view
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(sampleListings) { item in
                            ListingCardView(listing: item)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Marketplace")
            }
        }
    }
}

// MARK: - Listing Card View
struct ListingCardView: View {
    let listing: Listing

    var body: some View {
        VStack(alignment: .leading) {
            Image(listing.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .clipped()

            Text(listing.title)
                .font(.headline)
                .lineLimit(1)

            Text("$\(listing.price, specifier: "%.2f")")
                .foregroundColor(.green)
                .font(.subheadline)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}


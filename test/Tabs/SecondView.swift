//
//  SecondView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//

import SwiftUI

// MARK: - Listing Model
struct StudentListing: Identifiable {
    let id = UUID()
    let title: String
    let price: Double
    let imageName: String
    let location: String
    let category: String
}

// MARK: - Sample Data
let studentListings: [StudentListing] = [
    StudentListing(title: "Calculus Textbook", price: 40, imageName: "sample_calculus", location: "Campus Bookstore", category: "Textbooks"),
    StudentListing(title: "MacBook Air 2019", price: 650, imageName: "sample_macbook", location: "Dorms", category: "Electronics"),
    StudentListing(title: "Organic Chemistry Notes", price: 10, imageName: "sample_notes", location: "Science Building", category: "Notes"),
    StudentListing(title: "TI-84 Calculator", price: 50, imageName: "sample_calculator", location: "Library", category: "Electronics"),
    StudentListing(title: "1-on-1 Math Tutoring", price: 25, imageName: "sample_tutoring", location: "Online", category: "Tutoring"),
    StudentListing(title: "Physics Lab Kit", price: 30, imageName: "sample_labkit", location: "Physics Lab", category: "Supplies"),
    StudentListing(title: "Psychology Flashcards", price: 8, imageName: "sample_flashcards", location: "Student Centre", category: "Notes"),
    StudentListing(title: "Desk Lamp", price: 15, imageName: "sample_lamp", location: "Dorms", category: "Supplies")
]

let studentCategories = [
    "Textbooks", "Electronics", "Notes", "Tutoring", "Supplies", "Furniture", "Other"
]

// MARK: - Main Student Marketplace View
struct SecondView: View {
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var showingNewListing = false
    @State private var listings: [StudentListing] = studentListings

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var filteredListings: [StudentListing] {
        listings.filter { listing in
            (selectedCategory == nil || listing.category == selectedCategory) &&
            (searchText.isEmpty || listing.title.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(red: 0.07, green: 0.07, blue: 0.07).ignoresSafeArea()
            VStack(spacing: 0) {
                // Header & Search
                VStack(alignment: .leading, spacing: 12) {
                    Text("Student Marketplace")
                        .font(.largeTitle).bold()
                        .foregroundColor(.green)
                        .padding(.top, 16)
                        .padding(.horizontal)

                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search student resources...", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .background(Color(red: 0.07, green: 0.07, blue: 0.07))

                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(studentCategories, id: \.self) { category in
                            Button(action: { selectedCategory = (selectedCategory == category ? nil : category) }) {
                                Text(category)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 18)
                                    .background(selectedCategory == category ? Color.green : Color.white.opacity(0.08))
                                    .foregroundColor(selectedCategory == category ? .black : .white)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                // Listings Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(filteredListings) { listing in
                            StudentListingCard(listing: listing)
                        }
                    }
                    .padding()
                }
            }

            // Floating Action Button
            Button(action: { showingNewListing = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .clipShape(Circle())
                    .shadow(radius: 6)
            }
            .padding()
            .sheet(isPresented: $showingNewListing) {
                NewListingView { newListing in
                    listings.insert(newListing, at: 0)
                }
            }
        }
    }
}

// MARK: - Listing Card
struct StudentListingCard: View {
    let listing: StudentListing
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.08))
                // Try to load from assets, fallback to system image
                if let uiImage = UIImage(named: listing.imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                } else {
                    Image(systemName: fallbackSystemImage(for: listing.category))
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                        .foregroundColor(.green)
                }
            }
            .frame(height: 100)

            Text(listing.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
            Text("$\(listing.price, specifier: "%.2f")")
                .foregroundColor(.green)
                .font(.subheadline)
            Text(listing.location)
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(10)
        .background(Color.black.opacity(0.7))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

// Helper to provide a fallback system image for each category
func fallbackSystemImage(for category: String) -> String {
    switch category {
    case "Textbooks": return "book.closed"
    case "Electronics": return "laptopcomputer"
    case "Notes": return "doc.text"
    case "Tutoring": return "person.2.fill"
    case "Supplies": return "cube.box"
    case "Furniture": return "bed.double"
    default: return "questionmark.square.dashed"
    }
}


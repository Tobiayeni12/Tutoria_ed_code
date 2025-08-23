//
//  ProfileView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//

import SwiftUI
import PhotosUI   // 👈 for the photo picker

struct ProfileView: View {
    var studentDetails: StudentDetails

    @State private var isShowingSettings = false
    @State private var isShowingHelp     = false
    @State private var isShowingAbout    = false
    @State private var isShowingWallet   = false

    // MARK: - Profile image state & persistence
    @AppStorage("profileImageData") private var profileImageData: Data?
    @State private var selectedItem: PhotosPickerItem?
    @State private var uiImage: UIImage?

    private var profileImage: Image? {
        if let uiImage { return Image(uiImage: uiImage) }
        if let data = profileImageData, let img = UIImage(data: data) {
            return Image(uiImage: img)
        }
        return nil
    }

    var body: some View {
        ZStack {
            // Brand background
            Color.green.ignoresSafeArea()
            Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
            Circle().scale(1.35).foregroundColor(.white)

            ScrollView {
                VStack(spacing: 20) {
                    // Title
                    HStack {
                        Text("Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 20)

                    // User Details + Photo
                    Card {
                        HStack(alignment: .center, spacing: 16) {
                            ZStack {
                                // Avatar circle
                                if let profileImage {
                                    profileImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 88, height: 88)
                                        .clipShape(Circle())
                                } else {
                                    // Placeholder
                                    Circle()
                                        .fill(Color.green.opacity(0.15))
                                        .frame(width: 88, height: 88)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 44, height: 44)
                                                .foregroundColor(.green)
                                        )
                                }

                                // Small camera badge on the avatar
                                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.black.opacity(0.75))
                                            .frame(width: 28, height: 28)
                                            .overlay(
                                                Image(systemName: "camera.fill")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(.white)
                                            )
                                            .shadow(radius: 2, y: 1)
                                    }
                                }
                                .buttonStyle(.plain)
                                .offset(x: 32, y: 32) // bottom-right corner
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                InfoRow(label: "Full Name", value: studentDetails.fullName)
                                InfoRow(label: "Level of Education", value: studentDetails.levelOfEducation)
                                if studentDetails.levelOfEducation == "University" {
                                    InfoRow(label: "University", value: studentDetails.universityName)
                                    InfoRow(label: "Year of Study", value: studentDetails.yearOfStudy)
                                    InfoRow(label: "Major", value: studentDetails.major)
                                } else {
                                    InfoRow(label: "High School", value: studentDetails.highSchoolName)
                                }

                                // Secondary "Change Photo" button (optional, for clarity)
                                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                                    Label("Change Photo", systemImage: "photo.on.rectangle")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                }
                                .buttonStyle(.plain)
                                .padding(.top, 4)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 20)

                    // Second card (placeholder)
                    Card {
                        Text("Second Bubble Section")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)

                    // Actions card
                    Card(spacing: 0) {
                        RowButton(title: "Settings", icon: "gearshape", tint: .green) {
                            isShowingSettings = true
                        }
                        Divider()
                        RowButton(title: "Help", icon: "questionmark.circle", tint: .blue) {
                            isShowingHelp = true
                        }
                        Divider()
                        RowButton(title: "About", icon: "info.circle", tint: .purple) {
                            isShowingAbout = true
                        }
                        Divider()
                        RowButton(title: "Wallet", icon: "creditcard", tint: .orange) {
                            isShowingWallet = true
                        }
                    }
                    .padding(.horizontal, 20)

                    // Hidden navigation links
                    NavigationLink(destination: SettingsView(isActive: $isShowingSettings), isActive: $isShowingSettings) { EmptyView() }
                    NavigationLink(destination: HelpView(),  isActive: $isShowingHelp)  { EmptyView() }
                    NavigationLink(destination: AboutView(), isActive: $isShowingAbout) { EmptyView() }
                    NavigationLink(destination: WalletView(), isActive: $isShowingWallet) { EmptyView() }

                    Spacer(minLength: 24)
                }
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .scrollDisabled(true)
            .scrollIndicators(.hidden)
        }
        .navigationBarHidden(true)
        .onChange(of: selectedItem) { _, newItem in
            Task { await loadImage(from: newItem) } // handle photo selection
        }
    }

    // Load selected image, update UI and persist using AppStorage
    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item else { return }
        if let data = try? await item.loadTransferable(type: Data.self),
           let img = UIImage(data: data) {
            // Optionally downscale to keep storage small
            let compressed = img.jpegData(compressionQuality: 0.85)
            self.uiImage = img
            self.profileImageData = compressed ?? data
        }
    }
}

// MARK: - Reusable Bits

/// White rounded card with subtle shadow
private struct Card<Content: View>: View {
    var spacing: CGFloat = 12
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
        )
    }
}

/// Label/value row used in the info card
private struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(label):")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.55))
            Text(value)
                .font(.headline)
                .foregroundColor(.black)
        }
    }
}

/// Row-style button with icon + chevron
private struct RowButton: View {
    let title: String
    let icon: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(tint.opacity(0.15))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .foregroundColor(tint)
                }
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.black.opacity(0.35))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 10)
    }
}

//
//  NewListingView.swift
//  test
//
//  Created by Mack Ndanina on 2025-07-02.
//

import SwiftUI
import PhotosUI

struct NewListingView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Photo")) {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                        } else {
                            Label("Add Photo", systemImage: "camera")
                        }
                    }
                }

                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Description", text: $description)
                }

                Section {
                    Button("Post Listing") {
                        print("Posted: \(title), $\(price), \(description)")
                        // Add to listing array logic here
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty || price.isEmpty || selectedImage == nil)
                }
            }
            .navigationTitle("New Listing")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}

import SwiftUI
import PhotosUI

struct NewListingView: View {
    var onAdd: (StudentListing) -> Void

    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var selectedCategory: String = "Textbooks"
    @State private var location: String = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showPhotoSourceActionSheet = false

    let categories = [
        "Textbooks", "Electronics", "Notes", "Tutoring", "Supplies", "Furniture", "Other"
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Photo Section
                    VStack(spacing: 10) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 180)
                                .cornerRadius(14)
                                .onTapGesture { showPhotoSourceActionSheet = true }
                        } else {
                            Button(action: { showPhotoSourceActionSheet = true }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.green)
                                    Text("Add Photo")
                                        .foregroundColor(.green)
                                }
                                .padding()
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(14)
                            }
                        }
                    }

                    // Details Section
                    VStack(alignment: .leading, spacing: 16) {
                        TextField("Item Name", text: $title)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        TextField("Price", text: $price)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        TextField("Description", text: $description, axis: .vertical)
                            .lineLimit(3...6)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { cat in
                                Text(cat)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        TextField("Location (e.g. Campus, Dorm, Library)", text: $location)
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }

                    // Post Button
                    Button(action: {
                        let newListing = StudentListing(
                            title: title,
                            price: Double(price) ?? 0.0,
                            imageName: selectedImage != nil ? "user_uploaded_image" : fallbackSystemImage(for: selectedCategory),
                            location: location,
                            category: selectedCategory
                        )
                        onAdd(newListing)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Post Listing")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background((title.isEmpty || price.isEmpty || selectedImage == nil) ? Color.gray : Color.green)
                            .cornerRadius(12)
                    }
                    .disabled(title.isEmpty || price.isEmpty || selectedImage == nil)
                }
                .padding()
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.07).ignoresSafeArea())
            .navigationTitle("New Listing")
            .navigationBarTitleDisplayMode(.inline)
            .actionSheet(isPresented: $showPhotoSourceActionSheet) {
                ActionSheet(title: Text("Add Photo"), message: nil, buttons: [
                    .default(Text("Camera")) { showCamera = true },
                    .default(Text("Photo Library")) { showImagePicker = true },
                    .cancel()
                ])
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
            .sheet(isPresented: $showCamera) {
                CameraView(image: $selectedImage)
            }
        }
    }
}

// Dummy CameraView for placeholder (implement as needed)
struct CameraView: View {
    @Binding var image: UIImage?
    var body: some View {
        Text("Camera not implemented in this demo.")
            .onAppear { /* Integrate real camera if needed */ }
    }
} 
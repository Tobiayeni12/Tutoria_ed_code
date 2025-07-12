//
//  ThirdView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//

import SwiftUI
import MapKit
import CoreLocation

struct ThirdView: View {
    @State private var searchText = ""
    @State private var showBubble1 = false
    @State private var showBubble2 = false
    @State private var showBubble3 = false
    @State private var showSearchBar = false
    @FocusState private var isSearchFocused: Bool
    @State private var selectedSubject: String? = nil
    @State private var showMapSheet = false
    @StateObject private var locationManager = LocationManager()
    // Static list of university subjects
    let allSubjects = [
        "Agriculture and Bioresources",
        "Anatomy and Cell Biology",
        "Anthropology",
        "Art and Art History",
        "Biochemistry",
        "Biology",
        "Business",
        "Chemistry",
        "Civil Engineering",
        "Computer Science",
        "Drama",
        "Economics",
        "Education",
        "Electrical Engineering",
        "English",
        "Geography",
        "Geology",
        "History",
        "Kinesiology",
        "Law",
        "Mathematics",
        "Mechanical Engineering",
        "Medicine",
        "Music",
        "Nursing",
        "Philosophy",
        "Physics",
        "Political Studies",
        "Psychology",
        "Sociology",
        "Toxicology",
        "Veterinary Medicine"
    ]

    // Computed property for filtered suggestions
    var filteredSubjects: [String] {
        guard !searchText.isEmpty else { return [] }
        return allSubjects.filter { $0.localizedCaseInsensitiveContains(searchText) }.prefix(5).map { $0 }
    }

    var body: some View {
        ZStack {
            // Near-black dark grey background
            Color(red: 0.07, green: 0.07, blue: 0.07).ignoresSafeArea()
            // Green glow behind bubbles
            VStack {
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.5))
                        .frame(width: 350, height: 350)
                        .blur(radius: 60)
                }
                .frame(height: 0) // So it doesn't push content down
                Spacer()
            }

            VStack {
                Spacer()
                VStack(alignment: .center, spacing: 20) {
                    // Suggestions list (now above search bar)
                    if !filteredSubjects.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(filteredSubjects, id: \.self) { subject in
                                Text(subject)
                                    .frame(maxWidth: 300, minHeight: 40)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                                    .multilineTextAlignment(.center)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(Color.white.opacity(0.15)), alignment: .bottom
                                    )
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedSubject = subject
                                        showMapSheet = true
                                    }
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom, 4)
                        .transition(.opacity)
                    }
                    // Bubbles/Buttons (fade away when typing)
                    if filteredSubjects.isEmpty {
                        VStack(alignment: .center, spacing: 15) {
                            BubbleButton(title: "Engineering")
                                .opacity(showBubble1 ? 1 : 0)
                                .animation(.easeOut(duration: 0.5).delay(0.1), value: showBubble1)
                                .onTapGesture {
                                    selectedSubject = "Engineering"
                                    showMapSheet = true
                                }
                            BubbleButton(title: "Computer Science")
                                .opacity(showBubble2 ? 1 : 0)
                                .animation(.easeOut(duration: 0.5).delay(0.3), value: showBubble2)
                                .onTapGesture {
                                    selectedSubject = "Computer Science"
                                    showMapSheet = true
                                }
                            BubbleButton(title: "Kinesiology")
                                .opacity(showBubble3 ? 1 : 0)
                                .animation(.easeOut(duration: 0.5).delay(0.5), value: showBubble3)
                                .onTapGesture {
                                    selectedSubject = "Kinesiology"
                                    showMapSheet = true
                                }
                        }
                        .transition(.opacity)
                    }
                    // Search bar
                    TextField("", text: $searchText)
                        .padding(10)
                        .background(Color.clear)
                        .cornerRadius(10)
                        .frame(maxWidth: 300)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(showSearchBar ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.7), value: showSearchBar)
                        .focused($isSearchFocused)
                        .modifier(WhitePlaceholderStyle(show: searchText.isEmpty && !isSearchFocused, fadeIn: showSearchBar))
                    // Thin horizontal line under search bar, closer to the text
                    Rectangle()
                        .fill(Color.white.opacity(showSearchBar ? 1 : 0))
                        .frame(height: 1)
                        .frame(maxWidth: 300)
                        .padding(.top, -6)
                        .animation(.easeOut(duration: 0.5).delay(0.7), value: showSearchBar)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                showBubble1 = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showBubble2 = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    showBubble3 = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    showSearchBar = true
                }
            }
            .sheet(isPresented: $showMapSheet) {
                TutorMapSheet(subject: selectedSubject ?? "", tutors: [], userLocation: locationManager.userLocation)
            }
        }
    }
}

struct BubbleButton: View {
    var title: String

    var body: some View {
        Text(title)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(Color.white)
            .foregroundColor(.black)
            .clipShape(Capsule())
            .shadow(radius: 2)
    }
}

// Custom ViewModifier to set placeholder color in TextField and fade in
struct WhitePlaceholderStyle: ViewModifier {
    var show: Bool
    var fadeIn: Bool
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            if show {
                Text("Search for subjects")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
                    .padding(10)
                    .opacity(fadeIn ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.7), value: fadeIn)
            }
            content
                .opacity(show ? 0.85 : 1)
        }
    }
}

// MARK: - TutorMapSheet
enum MapAnnotationItem: Identifiable {
    case user(location: CLLocationCoordinate2D)
    case tutor(Tutor)

    var id: String {
        switch self {
        case .user:
            return "user-location"
        case .tutor(let tutor):
            return tutor.id.uuidString
        }
    }

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .user(let location):
            return location
        case .tutor(let tutor):
            return tutor.location
        }
    }

    var markerTitle: String {
        switch self {
        case .user:
            return "You"
        case .tutor(let tutor):
            return tutor.name
        }
    }

    var markerColor: Color {
        switch self {
        case .user:
            return .blue
        case .tutor:
            return .green
        }
    }
}

@available(iOS 17.0, *)
struct TutorMapSheet: View {
    var subject: String
    var tutors: [Tutor]
    var userLocation: CLLocationCoordinate2D?

    var annotationItems: [MapAnnotationItem] {
        var items: [MapAnnotationItem] = tutors.map { .tutor($0) }
        if let userLocation = userLocation {
            items.append(.user(location: userLocation))
        }
        return items
    }

    var body: some View {
        VStack(spacing: 0) {
            Map(
                coordinateRegion: .constant(MKCoordinateRegion(
                    center: userLocation ?? CLLocationCoordinate2D(latitude: 52.1332, longitude: -106.6700),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )),
                annotationItems: annotationItems
            ) { item in
                switch item {
                case .user:
                    MapMarker(coordinate: item.coordinate, tint: .blue)
                case .tutor:
                    MapMarker(coordinate: item.coordinate, tint: .green)
                }
            }
            .frame(height: 300)
            .cornerRadius(20)
            .padding()

            // Tutors list or no tutors available
            if tutors.isEmpty {
                Text("no tutors available")
                    .foregroundColor(.white)
                    .padding(.top, 24)
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(tutors) { tutor in
                            TutorCard(tutor: tutor)
                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }
        .background(Color(red: 0.07, green: 0.07, blue: 0.07))
    }
}

// MARK: - Tutor Model & Card
struct Tutor: Identifiable {
    let id = UUID()
    let name: String
    let location: CLLocationCoordinate2D
}

struct TutorCard: View {
    let tutor: Tutor
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.green)
            VStack(alignment: .leading) {
                Text(tutor.name)
                    .foregroundColor(.white)
                    .font(.headline)
                Text("Nearby")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D? = nil

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last?.coordinate
        print("Updated user location: \(String(describing: userLocation))")
    }
}


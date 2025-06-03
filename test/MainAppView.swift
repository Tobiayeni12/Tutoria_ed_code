//
//  MainAppView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-03-14.
//
import SwiftUI

struct MainAppView: View {
    @State private var selectedTab = 0
    var studentDetails: StudentDetails?

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                FirstView()
                    .tag(0)
                
                SecondView()
                    .tag(1)
                
                ThirdView()
                    .tag(2)
                
                FourthView()
                    .tag(3)
                
                // Wrap ProfileView in a NavigationStack
                NavigationStack {
                    ProfileView(studentDetails: studentDetails ?? StudentDetails(
                        fullName: "Unknown",
                        levelOfEducation: "Unknown",
                        highSchoolName: "",
                        universityName: "",
                        yearOfStudy: "",
                        major: ""
                    ))
                }
                .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)

            // Tab Bar
            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { index in
                    TabBarButton(
                        systemName: tabBarItems[index].icon,
                        label: tabBarItems[index].label,
                        isSelected: selectedTab == index
                    ) {
                        selectedTab = index
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 60)
            .background(Color.black.edgesIgnoringSafeArea(.bottom))
        }
        .edgesIgnoringSafeArea(.all)
    }

    private let tabBarItems: [(icon: String, label: String)] = [
        ("house", "Home"),
        ("storefront", "Marketplace"),
        ("plus.circle", "Request"),
        ("calendar", "Calendar"),
        ("person", "Profile")
    ]
}

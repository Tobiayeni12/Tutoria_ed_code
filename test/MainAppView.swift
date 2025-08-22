//
//  MainAppView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-03-14.
//
import SwiftUI

struct MainAppView: View {
    @State private var selectedTab = 0
    @State private var showTabBar = true
    var studentDetails: StudentDetails?

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                FirstView(showTabBar: $showTabBar, selectedTab: $selectedTab)
                    .tag(0)

                SecondView()
                    .tag(1)

                ThirdView()
                    .tag(2)

                CalendarView()
                    .tag(3)

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

            // Tab Bar — flat design without rounded corners
            if showTabBar {
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
                .padding(.top, 12)
                .padding(.bottom, 30) // lifts it above swipe area
                .background(
                    Color.black
                        .edgesIgnoringSafeArea(.bottom)
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: showTabBar)
            }
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

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
        ZStack {
            // CONTENT
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
                    ProfileView(
                        studentDetails: studentDetails ?? StudentDetails(
                            fullName: "Unknown",
                            levelOfEducation: "Unknown",
                            highSchoolName: "",
                            universityName: "",
                            yearOfStudy: "",
                            major: ""
                        )
                    )
                }
                .tag(4)
            }
            .tabViewStyle(.automatic)            // no paging => no swipe
            .toolbar(.hidden, for: .tabBar)      // hide system tab bar
            .edgesIgnoringSafeArea(.all)
        }
        // Render YOUR custom bar as a safe-area inset so content never sits under it
        .safeAreaInset(edge: .bottom) {
            if showTabBar {
                HStack(spacing: 0) {
                    ForEach(0..<tabBarItems.count, id: \.self) { index in
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
                .padding(.vertical, 8)                 // even padding (no gap/strip above)
                .background(Color.black)               // only the bar; no overlay above it
                .animation(.easeInOut(duration: 0.3), value: showTabBar)
            } else {
                // When hidden, reserve 0 height
                Color.clear.frame(height: 0)
            }
        }
    }

    private let tabBarItems: [(icon: String, label: String)] = [
        ("house", "Home"),
        ("storefront", "Marketplace"),
        ("plus.circle", "Request"),
        ("calendar", "Calendar"),
        ("person", "Profile")
    ]
}


//
//  FirstView.swift
//  test
//
//  Created by Tobi Ayeni on 2025-05-08.
//
import SwiftUI
import AVKit

struct FirstView: View {
    @Binding var showTabBar: Bool
    @Binding var selectedTab: Int
    @State private var showText = false
    @State private var showFeatures = false

    private let player = VideoPlaybackManager.shared.player

    var body: some View {
        ZStack {
            // 🔁 Background video
            VideoPlayerView(player: player)
                .ignoresSafeArea()
                .onAppear {
                    player.play()
                    player.isMuted = true
                }

            // ☁️ Fade overlay if features shown
            if showFeatures {
                Rectangle()
                    .fill(Color.white)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            VStack {
                Spacer()

                if !showFeatures {
                    // 🎬 Intro text
                    Text("Your all in one university sidekick")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .opacity(showText ? 1 : 0)
                        .animation(.easeIn(duration: 2.0), value: showText)

                    // ✅ Get Started Button
                    Button(action: {
                        withAnimation {
                            showFeatures = true
                            showTabBar = true
                        }
                    }) {
                        Text("Get Started")
                            .foregroundColor(.white)
                            .padding()
                            .padding(.horizontal, 20)
                            .background(Color.green)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                    .padding(.top, 20)
                } else {
                    // 📦 Features view
                    VStack(spacing: 25) {
                        featureCard(title: "Marketplace", description:
                            "Want to find school essentials at affordable prices but don’t know where to look? The Marketplace connects students with each other to buy, sell, or trade school necessities easily and securely."
                        )
                        featureCard(title: "Request a Tutor", description:
                            "Find and connect with experienced tutors for personalized help in your courses. Quick, easy, and right from your phone."
                        )
                        featureCard(title: "Calendar", description:
                            "Stay on top of assignments, tests, and classes. Your academic planner, always up to date and in your pocket."
                        )
                    }
                    .padding()
                    .background(
                        ZStack {
                            Color.white
                            Image("green_splatter")
                                .resizable()
                                .scaledToFit()
                                .opacity(0.1)
                                .rotationEffect(.degrees(-20))
                                .offset(x: -30, y: -40)
                        }
                    )
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .gesture(
                        DragGesture().onEnded { value in
                            if value.translation.height > 100 {
                                withAnimation {
                                    showFeatures = false
                                    showTabBar = false
                                }
                            }
                        }
                    )
                }

                Spacer()
            }
            .onAppear {
                showText = true
            }
            .padding()
        }
    }

    func featureCard(title: String, description: String) -> some View {
        VStack(spacing: 15) {
            Text(title)
                .font(.custom("MarkerFelt-Wide", size: 20))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            Text(description)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if title == "Marketplace" {
                Button(action: {
                    selectedTab = 1
                }) {
                    Text("Go now!")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(Color.green)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

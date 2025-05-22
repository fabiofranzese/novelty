//
//  OnboardingView.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI
import UserNotifications

struct OnboardingView: View {
    @AppStorage("onboarding") var onboarding = false
    @EnvironmentObject var manager : NoveltyManager
    @EnvironmentObject var timeManager: TimeManager
    
    @State private var viewcontroller: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to Novelty")
                .font(.largeTitle)
                .bold()
            
            Text("Each day you'll receive a small disruption to your routine — a fun and mindful challenge.")
                .multilineTextAlignment(.center)
            
            Button("Enable Notifications") {
                requestNotificationPermission()
            }
            
            Button("Get Started") {
                onboarding = true
                manager.proposeNewNovelty()
                print(onboarding)
                print(manager.todayNovelty?.title, manager.todayNovelty?.id)
                print("Current time: \(timeManager.currentTime.timeIntervalSince1970)")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            viewcontroller = onboarding
        }
        .onChange(of: onboarding) { newValue in
            viewcontroller = newValue
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                print("Notifications authorized ✅")
            }
        }
    }
}

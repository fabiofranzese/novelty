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
                .font(.extrabold(size: 40))
                .multilineTextAlignment(.leading)
            
            Text("Each day you'll receive a small disruption to your routine — a fun and mindful challenge.")
                .multilineTextAlignment(.leading)
                .font(.regular(size: 20))
            
            Button(action: {requestNotificationPermission()}) {Text("Enable Notification").font(.italic(size: 20))
                .multilineTextAlignment(.leading)}
            
            Button(action: {onboarding = true
                manager.proposeNewNovelty()
                print(onboarding)
                print(manager.todayNovelty?.title, manager.todayNovelty?.id)
                print("Current time: \(timeManager.currentTime.timeIntervalSince1970)")
            }) {Text("Get Started").font(.italic(size: 20))
                .multilineTextAlignment(.leading)}
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

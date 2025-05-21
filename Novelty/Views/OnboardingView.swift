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
                NotificationScheduler.scheduleDailyNotification()
                print(onboarding)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if granted {
                print("Notifications authorized ✅")
            }
        }
    }
}
#Preview {
    OnboardingView()
}

//
//  MotorView.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI

struct MotorView: View {
    @EnvironmentObject var manager: NoveltyManager
    
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
    var body: some View {
        NavigationStack {
            
            Text("Motor Novelty")
            Text(manager.todayNovelty?.title ?? "No Novelty")
            HStack {
                Button("Discard") {
                    manager.discardTodayNovelty()
                    print("Novelty Discarded", NextNoveltyTime, NextNoveltyId)
                }.buttonStyle(.borderedProminent)
                Button("Accept") {
                    manager.acceptTodayNovelty()
                    manager.doTodayNovelty()
                    print("Novelty accepted and done", NextNoveltyTime, NextNoveltyId)
                }.buttonStyle(.borderedProminent)
                Button("Delay") {
                    NotificationScheduler.delayNotification()
                    print("Notification Delayed", NextNoveltyTime, NextNoveltyId)
                }.buttonStyle(.borderedProminent)
            }
            
            Button("Reset") {
                onboarding = false
                NextNoveltyId = ""
                NextNoveltyTime = Double.infinity
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

//
//  NoveltyApp.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI

@main
struct contemplativeApp: App {
    @StateObject var manager = NoveltyManager()
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
    var body: some Scene {
        WindowGroup {
            if onboarding {
                if Date() >= Date(timeIntervalSince1970: NextNoveltyTime) {
                    NoveltyRouterView(novelty: manager.todayNovelty!)
                        .environmentObject(manager)
                } else {
                    MainView()
                        .environmentObject(manager)
                }
            } else {
                OnboardingView()
                    .environmentObject(manager)
            }
        }
    }
}


//
//  RootRouterView.swift
//  Novelty
//
//  Created by Fabio on 22/05/25.
//

import SwiftUI

struct RootRouterView: View {
    @EnvironmentObject var manager: NoveltyManager
    @EnvironmentObject var timeManager: TimeManager
    
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity

    var body: some View {
        Group {
            if onboarding {
                if timeManager.currentTime >= Date(timeIntervalSince1970: NextNoveltyTime) {
                    if let novelty = manager.todayNovelty {
                        NoveltyRouterView(novelty: novelty)
                            .environmentObject(manager)
                    } else {
                        Text("No novelty loaded.")
                    }
                } else {
                    MainView()
                        .environmentObject(manager)
                        .environmentObject(timeManager)
                }
            } else {
                OnboardingView()
                    .environmentObject(manager)
                    .environmentObject(timeManager)
            }
        }
    }
}

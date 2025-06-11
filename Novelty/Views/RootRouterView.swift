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
    @EnvironmentObject var noveltyTimerManager: NoveltyTimerManager
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity

    var body: some View {
        Group {
            if onboarding {
                if timeManager.currentTime >= Date(timeIntervalSince1970: NextNoveltyTime) {
                    if let novelty = manager.todayNovelty {
                        NoveltyRouterView()
                            .environmentObject(manager)
                            .environmentObject(noveltyTimerManager)
                            .animation(.easeOut(duration: 0.5), value: timeManager.currentTime >= Date(timeIntervalSince1970: NextNoveltyTime))
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        Text("No novelty loaded.")
                    }
                } else {
                    MainView()
                        .environmentObject(manager)
                        .environmentObject(timeManager)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            } else {
                Onboarding()
                    .environmentObject(manager)
                    .environmentObject(timeManager)
                    .animation(.easeOut(duration: 0.5), value: onboarding)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

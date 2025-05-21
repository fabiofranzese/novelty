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
    var body: some Scene {
        WindowGroup {
            if onboarding {
                MainView()
            } else {
                OnboardingView()
            }
        }
    }
}


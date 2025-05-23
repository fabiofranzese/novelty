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
    @StateObject var timeManager = TimeManager()
    @State private var currentTime = Date()
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
    @AppStorage("CurrentNoveltyStatus") var CurrentNoveltyStatus: NoveltyStatus = .proposed
    var body: some Scene {
        WindowGroup {
            RootRouterView()
                .environmentObject(manager)
                .environmentObject(timeManager)
        }
    }
}


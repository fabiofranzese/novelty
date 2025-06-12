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
    @StateObject var noveltyTimerManager = NoveltyTimerManager()
    @State private var currentTime = Date()
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
    @AppStorage("CurrentNoveltyStatus") var CurrentNoveltyStatus: NoveltyStatus = .proposed
    @AppStorage("id") var id: String = "1"
    @AppStorage("StartDate") var StartDate: TimeInterval = Date(timeIntervalSinceNow: -86400*10).timeIntervalSince1970
    var body: some Scene {
        WindowGroup {
            RootRouterView()
                .environmentObject(manager)
                .environmentObject(timeManager)
                .environmentObject(noveltyTimerManager)
        }
    }
}

extension Font {
    static func extrabold(size: CGFloat) -> Font {
        return .custom("AlbertSansRoman-ExtraBold", size: size)
    }
    static func italic(size: CGFloat) -> Font {
        return .custom("AlbertSansRoman-Light", size: size)
    }
    static func regular(size: CGFloat) -> Font {
        return .custom("AlbertSansRoman-Regular", size: size)
    }
    static func bold(size: CGFloat) -> Font {
        return .custom("AlbertSansRoman-Bold", size: size)
    }
}

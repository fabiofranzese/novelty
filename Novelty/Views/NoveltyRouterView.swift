//
//  NoveltyRouterView.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI

struct NoveltyRouterView: View {
    @EnvironmentObject var manager : NoveltyManager
    @EnvironmentObject private var noveltyTimerManager: NoveltyTimerManager
    @AppStorage("CurrentNoveltyStatus") var CurrentNoveltyStatus: NoveltyStatus = .proposed
    
    var body: some View {
        NavigationStack {
            switch manager.todayNovelty?.category.rawValue ?? "unknown" {
            case "s":
                GeneralNoveltyProposalView()
                    .environmentObject(manager)
                    .environmentObject(noveltyTimerManager)
            case "m":
                GeneralNoveltyProposalView()
                    .environmentObject(manager)
                    .environmentObject(noveltyTimerManager)
            case "c":
                GeneralNoveltyProposalView()
                    .environmentObject(manager)
                    .environmentObject(noveltyTimerManager)
            case "d":
                GeneralNoveltyProposalView()
                    .environmentObject(manager)
                    .environmentObject(noveltyTimerManager)
            default:
                let status = manager.todayNovelty?.status
                if status == .asking {
                    NoveltyAskingView()
                        .environmentObject(manager)
                        .environmentObject(noveltyTimerManager)
                } else if status == .proposed {
                    GeneralNoveltyProposalView()
                        .environmentObject(manager)
                        .environmentObject(noveltyTimerManager)
                } else if status == .accepted{
                    MidNoveltyView()
                        .environmentObject(manager)
                        .environmentObject(noveltyTimerManager)
                } else if status == .feedback {
                    Button("Do Feedback"){
                        manager.doTodayNoveltyFeedback()
                        // Manage end of live activity
                    }
                } else {
                    Text("\(manager.todayNovelty?.status?.rawValue), \(manager.todayNovelty?.title)")
                }
            }
        }
    }
}

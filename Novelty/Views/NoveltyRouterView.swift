//
//  NoveltyRouterView.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI

struct NoveltyRouterView: View {
    @EnvironmentObject var manager : NoveltyManager
    @State private var noveltyTimerManager = NoveltyTimerManager()
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
                if status == .proposed {
                    GeneralNoveltyProposalView()
                        .environmentObject(manager)
                        .environmentObject(noveltyTimerManager)
                } else if status == .accepted{
                    Text("Accepted")
                    Button("Complete"){
                        manager.doTodayNovelty()
                        noveltyTimerManager.endLiveActivity()
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Text("\(manager.todayNovelty?.status?.rawValue), \(manager.todayNovelty?.title)")
                }
            }
        }
    }
}

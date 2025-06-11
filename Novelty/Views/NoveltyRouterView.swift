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
            ZStack{
                BackgroundView(color1: Color(hex: manager.todayNovelty?.colors?[0] ?? "000000"),
                               color2: Color(hex: manager.todayNovelty?.colors?[1] ?? "000000"),
                               color3: Color(hex: manager.todayNovelty?.colors?[2] ?? "000000"),
                               color4: Color(hex: manager.todayNovelty?.colors?[3] ?? "000000"))
                    .ignoresSafeArea()
                Group {
                    switch manager.todayNovelty?.category.rawValue ?? "unknown" {
                    case "s", "m", "c", "d":
                        GeneralNoveltyProposalView()
                            .environmentObject(manager)
                            .environmentObject(noveltyTimerManager)
                            .transition(.opacity)
                    default:
                        let status = manager.todayNovelty?.status
                        if status == .asking {
                            NoveltyAskingView()
                                .environmentObject(manager)
                                .environmentObject(noveltyTimerManager)
                                .transition(.opacity)
                        } else if status == .proposed {
                            GeneralNoveltyProposalView()
                                .environmentObject(manager)
                                .environmentObject(noveltyTimerManager)
                                .transition(.opacity)
                        } else if status == .accepted{
                            MidNoveltyView()
                                .environmentObject(manager)
                                .environmentObject(noveltyTimerManager)
                                .transition(.opacity)
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
    }
}

//
//  NoveltyRouterView.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI

struct NoveltyRouterView: View {
    @EnvironmentObject var manager : NoveltyManager
    @AppStorage("CurrentNoveltyStatus") var CurrentNoveltyStatus: NoveltyStatus = .proposed
    
    var body: some View {
        NavigationStack {
            switch manager.todayNovelty?.category.rawValue ?? "unknown" {
            case "s":
                GeneralNoveltyProposalView()
                    .environmentObject(manager)
            case "m":
                GeneralNoveltyProposalView()
                    .environmentObject(manager)
            case "c":
                GeneralNoveltyProposalView()
                    .environmentObject(manager)
            case "d":
                GeneralNoveltyProposalView()
                    .environmentObject(manager)
            default:
                let status = manager.todayNovelty?.status
                if status == .proposed {
                    GeneralNoveltyProposalView()
                        .environmentObject(manager)
                } else if status == .accepted{
                    Text("Accepted")
                    Button("Complete"){
                        manager.doTodayNovelty()
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Text("\(manager.todayNovelty?.status?.rawValue), \(manager.todayNovelty?.title)")
                }
            }
        }
    }
}

//
//  NoveltyAskingView.swift
//  Novelty
//
//  Created by Fabio on 06/06/25.
//

import SwiftUI
import Foundation

struct NoveltyAskingView: View {
    @EnvironmentObject var manager: NoveltyManager
    @EnvironmentObject var timeManager: TimeManager
    @EnvironmentObject var noveltyTimerManager: NoveltyTimerManager
    
    var body: some View {
        VStack {
            Text("Do you have \(manager.todayNovelty?.duration!.format(using: [.minute, .second]) ?? "dontknow")?")
                .font(.extrabold(size: 40))
                .frame(alignment: .leading)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.trailing, 60)
            
            Button("Yes") {
                manager.proposeTodayNovelty()
            }
            Button("No") {
                NotificationManager.delayNotification(bySeconds: 120)
                manager.todayNovelty?.duration = TimeInterval.random(in: 120...300)
            }
        }
    }
    
    func randomtime() -> TimeInterval {
        return TimeInterval.random(in: 120...300)
    }
}

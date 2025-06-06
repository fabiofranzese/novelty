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
                .font(.largeTitle)
                .padding()
            
            Button("Yes") {
                manager.proposeTodayNovelty()
            }
            Button("No") {
                NotificationManager.delayNotification(bySeconds: 120)
                manager.todayNovelty?.duration = TimeInterval.random(in: 120...300)
            }
        }
        .padding()
    }
    
    func randomtime() -> TimeInterval {
        return TimeInterval.random(in: 120...300)
    }
}

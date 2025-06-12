//
//  MidNoveltyView.swift
//  Novelty
//
//  Created by Fabio on 28/05/25.
//

import SwiftUI

struct MidNoveltyView: View {
    @EnvironmentObject var manager: NoveltyManager
    @EnvironmentObject var noveltyTimerManager: NoveltyTimerManager
    @State private var noveltytime: Double = Double.infinity
    
    @AppStorage("onboarding") var onboarding: Bool = false
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("NextNoveltyTime") var NextNoveltyTime: Double = Double.infinity
    var body: some View {
        NavigationStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 30)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 300)
                
                Circle()
                    .trim(from: 0, to: CGFloat(noveltyTimerManager.progress))
                    .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(-90))
                    .foregroundColor(Color.purple.opacity(0.8))
                    .frame(width: 300, height: 300)
            }
        }
        .onAppear {
            noveltytime = NextNoveltyTime
            if !noveltyTimerManager.isTimerRunning{
                manager.doTodayNovelty()
                noveltyTimerManager.endLiveActivity()
            }
        }
        .onChange(of: NextNoveltyTime) { newValue in
            noveltytime = newValue
        }
        .onChange(of: noveltyTimerManager.isTimerRunning) { newValue in
            if !newValue {
                manager.doTodayNovelty()
                noveltyTimerManager.endLiveActivity()
            }
        }
    }
}

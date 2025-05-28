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
            
            Text("General Novelty")
            Text(manager.todayNovelty?.title ?? "No Novelty")
            VStack {
                Text("Accepted")
                ProgressView(value: noveltyTimerManager.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
                
                if !noveltyTimerManager.isTimerRunning{
                    Button("Feedback") {
                        manager.doTodayNovelty()
                        noveltyTimerManager.endLiveActivity()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            Button("Reset") {
                onboarding = false
                NextNoveltyId = ""
                NextNoveltyTime = Double.infinity
            }
            .buttonStyle(.borderedProminent)
        }.onAppear {
            noveltytime = NextNoveltyTime
        }
        .onChange(of: NextNoveltyTime) { newValue in
            noveltytime = newValue
        }
    }
}

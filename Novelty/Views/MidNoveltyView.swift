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
            VStack(alignment: .leading, spacing: 16) {
                Text(noveltyTimerManager.duration.format(using: [.minute, .second]))
                    .font(.extrabold(size: 40))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.trailing, 40)
            VStack {
                    ProgressView(value: noveltyTimerManager.progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
            }
        }
        .padding(.horizontal, 20)
        .padding(.trailing, 50)
        .onAppear {
            noveltytime = NextNoveltyTime
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

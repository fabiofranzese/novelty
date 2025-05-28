//
//  NoveltyTimerManager.swift
//  Novelty
//
//  Created by Fabio on 28/05/25.
//

import Foundation
import ActivityKit

class NoveltyTimerManager: ObservableObject {
    @Published var activity: Activity<TimerAttributes>?
    @Published var currentNovelty: Novelty?

    func startLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let attributes = TimerAttributes(novelty: currentNovelty)
        let contentState = TimerAttributes.ContentState(emoji: "😀")
        do {
            activity = try Activity<TimerAttributes>.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
        } catch {
            print("Failed to start live activity: \(error)")
        }
    }

    func endLiveActivity() {
        Task {
            for activity in Activity<TimerAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
            }
            self.activity = nil
        }
    }
}

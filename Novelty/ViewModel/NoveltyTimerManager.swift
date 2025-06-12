//
//  NoveltyTimerManager.swift
//  Novelty
//
//  Created by Fabio on 28/05/25.
//

import Foundation
import ActivityKit
import Combine

class NoveltyTimerManager: ObservableObject {
    @Published var activity: Activity<TimerAttributes>?
    @Published var currentNovelty: Novelty?
    @Published var duration: TimeInterval = 30
    @Published var totalDuration: TimeInterval = 30
    @Published var progress = 1.0
    @Published var isTimerRunning = false
    
    private var timerPublisher: Timer.TimerPublisher?
    private var timerCancellable: Cancellable?
    private var startDate: Date?
    

    func startLiveActivity() {
        //guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        //let attributes = TimerAttributes(novelty: currentNovelty)
        //let contentState = TimerAttributes.ContentState(emoji: "😀", timeLeft: duration, endDate: Date().addingTimeInterval(300))
        do {
//            activity = try Activity<TimerAttributes>.request(
//                attributes: attributes,
//                contentState: contentState,
//                pushType: nil
//            )
            startTimer()
        } catch {
            print("Failed to start live activity: \(error)")
        }
    }

    func endLiveActivity() {
        Task {
//            for activity in Activity<TimerAttributes>.activities {
//                await activity.end(dismissalPolicy: .immediate)
//            }
            stopTimer()
            //self.activity = nil
        }
    }
    
    private func startTimer() {
        stopTimer()
        startDate = Date()
        isTimerRunning = true
        timerPublisher = Timer.publish(every: 0.5, on: .main, in: .common)
        timerCancellable = timerPublisher?
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateTimer()
            }
    }
    
    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        timerPublisher = nil
        isTimerRunning = false
        resetTimer()
    }
    
    private func updateTimer() {
        guard let startDate = startDate else { return }
        let elapsed = Date().timeIntervalSince(startDate)
        duration = max(totalDuration - elapsed, 0)
        progress = duration / totalDuration
        if let activity = activity {
            let contentState = TimerAttributes.ContentState(
                emoji: "😀",
                timeLeft: duration,
                endDate: Date().addingTimeInterval(duration)
            )
            Task {
                await activity.update(ActivityContent(state: contentState, staleDate: nil))
            }
        }
        if duration <= 0 {
            stopTimer()
            endLiveActivity()
        }
    }

        func resetTimer() {
            duration = totalDuration
            progress = 1.0
        }
}

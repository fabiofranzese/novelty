//
//  NoveltyManager.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import Foundation
import SwiftUI
class NoveltyManager: ObservableObject {
    @Published var todayNovelty: Novelty?
    @Published var history: [Novelty] = []
    private(set) var allNovelties: [Novelty] = []
    private(set) var allFeedbacks: [Feedback] = []
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    @AppStorage("CurrentNoveltyStatus") var CurrentNoveltyStatus: NoveltyStatus = .proposed
    @AppStorage("id") var id: String = "1"
    
    private let historyURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("novelty_history.json")
    
    let hexColors: [String] = [
        "FF383C", "FF4245", "E9152D", "FF6165",
        "FF8D28", "FF922E", "C55300", "FFA056",
        "FFCC00", "FFD600", "A16A00", "FEDF43",
        "34C759", "30D158", "008932", "4AD968",
        "C8C8B3", "00DAC3", "008579", "54DFCB",
        "00C3D0", "00D2E0", "008198", "3BDBEC",
        "00C0E8", "3CD3FE", "007EAE", "6DF9FF",
        "0088FF", "0091FF", "1E6EF4", "5CB8FF",
        "6155F5", "6B5DFF", "564ADE", "A7BEFF",
        "CB30E0", "DB34F2", "B02FC2", "EA93FF",
        "FF2D55", "FF375F", "E7124D", "FF8AC4"
    ]
    
    init() {
        loadNovelties()
        loadFeedbacks()
        loadHistory()
        loadTodayNovelty()
    }
    
    private func loadNovelties() {
        guard let url = Bundle.main.url(forResource: "novelties", withExtension: "json") else {
                print("Error: novelties.json not found in bundle.")
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let decodedNovelties = try JSONDecoder().decode([Novelty].self, from: data)
                self.allNovelties = decodedNovelties
                print("Loaded \(decodedNovelties.count) novelties from novelties.json")
            } catch {
                print("Failed to decode novelties.json: \(error)")
            }
        print(self.allNovelties.first!.title)
        }
    
    private func loadFeedbacks() {
        guard let url = Bundle.main.url(forResource: "feedbacks", withExtension: "json") else {
                print("Error: feedbacks.json not found in bundle.")
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let decodedFeedbacks = try JSONDecoder().decode([Feedback].self, from: data)
                self.allFeedbacks = decodedFeedbacks
                print("Loaded \(decodedFeedbacks.count) feedbacks from feedbacks.json")
            } catch {
                print("Failed to decode feedbacks.json: \(error)")
            }
        print(self.allFeedbacks.first!.feedbackquestion)
        }

        private func loadHistory() {
            if let data = try? Data(contentsOf: historyURL),
               let saved = try? JSONDecoder().decode([Novelty].self, from: data) {
                self.history = saved
                print(history.description)
            } else {
                self.history = []
            }
        }

        private func saveHistory() {
            if let data = try? JSONEncoder().encode(history) {
                try? data.write(to: historyURL)
            }
        }
    
        private func loadTodayNovelty() {
            self.todayNovelty = allNovelties.first {$0.id == NextNoveltyId}
            self.todayNovelty?.status = CurrentNoveltyStatus
            self.todayNovelty?.colors = Array(hexColors.shuffled().prefix(4))
            self.todayNovelty?.duration = TimeInterval.random(in: 120...300)
            self.todayNovelty?.feedback = allFeedbacks.randomElement() ?? Feedback(id: "01", feedbackquestion: "How was your experience?")
            print("id:", id)
        }

    func proposeNewNovelty() {
        var novelty = allNovelties.randomElement()!
        novelty.status = .asking
        novelty.duration = TimeInterval.random(in: 120...300)
        novelty.colors = Array(hexColors.shuffled().prefix(4))
        novelty.feedback = allFeedbacks.randomElement() ?? Feedback(id: "01", feedbackquestion: "How was your experience?")
        print(novelty.colors?.description ?? "No colors available")
        CurrentNoveltyStatus = .asking
        todayNovelty = novelty
        NextNoveltyId = novelty.id
        NotificationManager.scheduleDailyNotification()
    }
    
    func refreshNovelty(duration: TimeInterval) {
        var novelty = allNovelties.randomElement()!
        novelty.status = .proposed
        novelty.duration = duration
        novelty.colors = Array(hexColors.shuffled().prefix(4))
        novelty.feedback = allFeedbacks.randomElement() ?? Feedback(id: "01", feedbackquestion: "How was your experience?")
        print(novelty.colors?.description ?? "No colors available")
        CurrentNoveltyStatus = .proposed
        todayNovelty = novelty
        NextNoveltyId = novelty.id
    }
    
    func endonboarding() {
        var novelty = allNovelties.randomElement()!
        novelty.status = .asking
        novelty.duration = TimeInterval.random(in: 120...300)
        novelty.colors = Array(hexColors.shuffled().prefix(4))
        novelty.feedback = allFeedbacks.randomElement() ?? Feedback(id: "01", feedbackquestion: "How was your experience?")
        print(novelty.colors?.description ?? "No colors available")
        CurrentNoveltyStatus = .asking
        todayNovelty = novelty
        NextNoveltyId = novelty.id
        NotificationManager.delayNotification()
    }
    
    func proposeTodayNovelty() {
        todayNovelty?.status = .proposed
        CurrentNoveltyStatus = .proposed
    }
    
        func acceptTodayNovelty() {
            todayNovelty?.status = .accepted
            CurrentNoveltyStatus = .accepted
        }
    
        func discardTodayNovelty() {
            proposeNewNovelty()
        }
    
        func doTodayNovelty() {
            todayNovelty?.status = .feedback
            CurrentNoveltyStatus = .feedback
        }
    
        func doTodayNoveltyFeedback() {
            todayNovelty?.status = .completed
            CurrentNoveltyStatus = .completed
            todayNovelty?.id = self.id
            todayNovelty?.createdAt = Date()
            id = String(Int(id)! + 1)
            print(todayNovelty?.createdAt)
            print("id: \(id)")
            history.append(todayNovelty!)
            saveHistory()
            proposeNewNovelty()
        }
}

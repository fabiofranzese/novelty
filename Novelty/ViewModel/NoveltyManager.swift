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
    @AppStorage("NextNoveltyId") var NextNoveltyId: String = ""
    
    private let historyURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("novelty_history.json")

    private(set) var allNovelties: [Novelty] = []
    
    init() {
        loadNovelties()
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

        private func loadHistory() {
            if let data = try? Data(contentsOf: historyURL),
               let saved = try? JSONDecoder().decode([Novelty].self, from: data) {
                self.history = saved
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
        }

        func proposeNewNovelty() {
            let available = allNovelties.filter { novelty in
                !history.contains(where: { $0.id == novelty.id && $0.status == .completed })
            }

            guard let selected = available.randomElement() ?? allNovelties.randomElement() else { return }

            var novelty = selected
            novelty.createdAt = Date()
            novelty.status = .proposed
            todayNovelty = novelty
            NextNoveltyId = novelty.id

            history.append(novelty)
            saveHistory()
        }

    func updateTodayNoveltyStatus(to newStatus: NoveltyStatus) {
        guard var novelty = todayNovelty else { return }
        novelty.status = newStatus
        
        if let index = history.firstIndex(where: { $0.id == novelty.id }) {
            history[index] = novelty
        } else {
            history.append(novelty)
        }
        todayNovelty = novelty
        saveHistory()
    }
}

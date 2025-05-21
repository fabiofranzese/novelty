//
//  NoveltyManager.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import Foundation
class NoveltyManager: ObservableObject {
    @Published var todayNovelty: Novelty?
    @Published var allNovelties: [Novelty] = []
    
    init() {
        loadNovelties()
        loadTodayNovelty()
    }
    
    func loadNovelties() {
        
    }
    
    func loadTodayNovelty() {
        
    }
    
    func proposeNewNovelty() {
        
    }
    
    func updateStatus(_ status: NoveltyStatus){
        todayNovelty?.status = status
        saveToDisk()
    }
    
    func saveToDisk() {
        
    }
}

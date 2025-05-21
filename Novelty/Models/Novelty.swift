//
//  Novelry.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//
import Foundation

enum NoveltyCategory: String, Codable, CaseIterable {
    case sensorial
    case motor
    case cognitive
    case digital
}

enum NoveltyStatus: String, Codable {
    case proposed
    case accepted
    case completed
    case delayed
    case discarded
}

struct Novelty: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let category: NoveltyCategory
    var status: NoveltyStatus
    let duration: TimeInterval? // For time-based novelties
    let createdAt: Date
}

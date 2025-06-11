//
//  Novelry.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//
import Foundation


enum NoveltyStatus: String, Codable {
    case asking
    case proposed
    case accepted
    case completed
    case feedback
    case delayed
    case discarded
}

struct Novelty: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let category: String
    var duration: TimeInterval?
    var status: NoveltyStatus?
    var createdAt: Date?
    var colors: [String]?
    var feedback: Feedback?
}

struct Feedback: Identifiable, Codable {
    let id: String
    let feedbackquestion: String
    var feedbackanswer: String?
}

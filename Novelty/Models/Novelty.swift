//
//  Novelry.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//
import Foundation
import SwiftUI


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
    var id: String
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

extension AnyTransition {
    static var easeInOutTransition: AnyTransition {
        .opacity.combined(with: .scale(scale: 1.0)).animation(.easeInOut(duration: 0.5))
    }
}

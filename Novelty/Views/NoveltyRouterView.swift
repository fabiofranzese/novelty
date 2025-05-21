//
//  NoveltyRouterView.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import SwiftUI

struct NoveltyRouterView: View {
    let novelty: Novelty
    @EnvironmentObject var manager : NoveltyManager

    var body: some View {
        switch novelty.category.rawValue {
        case "sensory":
            SensoryView(novelty: novelty)
        case "motor":
            MotorView(novelty: novelty)
        case "cognitive":
            CognitiveView(novelty: novelty)
        case "digital":
            DigitalView(novelty: novelty)
        default:
            Text("Unsupported novelty type")
        }
    }
}

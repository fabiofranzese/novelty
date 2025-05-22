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
        switch manager.todayNovelty?.category.rawValue ?? "unknown" {
        case "sensory":
            SensoryView()
                .environmentObject(manager)
        case "motor":
            MotorView()
                .environmentObject(manager)
        case "cognitive":
            CognitiveView()
                .environmentObject(manager)
        case "digital":
            DigitalView()
                .environmentObject(manager)
        default:
            Text("Unsupported novelty type")
        }
    }
}

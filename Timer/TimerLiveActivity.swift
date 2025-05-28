//
//  TimerLiveActivity.swift
//  Timer
//
//  Created by Fabio on 28/05/25.
//

import ActivityKit
import WidgetKit
import SwiftUI
import Foundation

struct TimerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
        var timeLeft: TimeInterval
    }

    // Fixed non-changing properties about your activity go here!
    var novelty: Novelty?
}

struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Novelty: \(context.attributes.novelty?.title ?? "Unknown Novelty")")
                    .font(.headline)
                Text("Hello \(context.state.timeLeft.format(using: [.minute, .second]))")
                    .font(.subheadline)
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.center) {
                    Text("Novelty: \(context.attributes.novelty?.title ?? "Unknown Novelty")")
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Novelty: \(context.attributes.novelty?.description ?? "Unknown Novelty")")
                        .font(.headline)
                    Text("Time Left: \(context.state.timeLeft.format(using: [.minute, .second]))")
                        .font(.subheadline)
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimerAttributes {
    fileprivate static var preview: TimerAttributes {
        TimerAttributes()
    }
}

extension TimerAttributes.ContentState {
    fileprivate static var smiley: TimerAttributes.ContentState {
        TimerAttributes.ContentState(emoji: "😀", timeLeft: 300)
     }
     
     fileprivate static var starEyes: TimerAttributes.ContentState {
         TimerAttributes.ContentState(emoji: "🤩", timeLeft: 300)
     }
}

#Preview("Notification", as: .content, using: TimerAttributes.preview) {
   TimerLiveActivity()
} contentStates: {
    TimerAttributes.ContentState.smiley
    TimerAttributes.ContentState.starEyes
}

extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
}

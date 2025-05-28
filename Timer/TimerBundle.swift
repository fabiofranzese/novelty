//
//  TimerBundle.swift
//  Timer
//
//  Created by Fabio on 28/05/25.
//

import WidgetKit
import SwiftUI

@main
struct TimerBundle: WidgetBundle {
    var body: some Widget {
        Timer()
        TimerLiveActivity()
    }
}

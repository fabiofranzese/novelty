//
//  NotificationManager.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import Foundation
import UserNotifications

class NotificationScheduler {
    static func scheduleDailyNotification(at hour: Int = Int.random(in: 9...23)) {
        let content = UNMutableNotificationContent()
        content.title = "Your novelty is here"
        content.body = "Tap to view today's challenge."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = Int.random(in: 0...59)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "dailyNovelty",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Scheduled notification at \(String(format: "%02d", hour)):\(String(format: "%02d", dateComponents.minute ?? -1))")
            }
        }
    }
}

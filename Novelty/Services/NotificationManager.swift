//
//  NotificationManager.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationScheduler {
    
    static func scheduleDailyNotification(at hour: Int = Int.random(in: 9...23)) {
        let content = UNMutableNotificationContent()
        content.title = "Your novelty is here"
        content.body = "Tap to view today's challenge."
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        dateComponents.day! += 1
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
                print("Scheduled notification on \(String(format: "%02d", dateComponents.day ?? -1)) at \(String(format: "%02d", hour)):\(String(format: "%02d", dateComponents.minute ?? -1))")
                UserDefaults.standard.set(Calendar.current.date(from: dateComponents)?.timeIntervalSince1970, forKey: "NextNoveltyTime")
            }
        }
    }
}

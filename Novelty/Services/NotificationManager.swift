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
    
    static func scheduleDailyNotification(at hour: Int = 12) {
        let content = UNMutableNotificationContent()
        content.title = "Your novelty is here"
        content.body = "Tap to view today's challenge."
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .minute], from: Date())
        dateComponents.hour = hour
        dateComponents.minute! += 2
        

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
    
    static func delayNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Your delayed novelty is here"
        content.body = "Tap to view today's challenge."
        content.sound = .default
        

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "dailyNovelty",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Scheduled notification in 10 minutes")
                UserDefaults.standard.set(Date().addingTimeInterval(120).timeIntervalSince1970, forKey: "NextNoveltyTime")
            }
        }
    }
}

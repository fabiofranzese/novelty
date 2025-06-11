//
//  NotificationManager.swift
//  Novelty
//
//  Created by Fabio on 21/05/25.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager {
    
    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Your novelty is here"
        content.body = "Tap to view today's challenge."
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .hour, .day, .minute], from: Date())
        dateComponents.minute! += 1
        

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
                print(Calendar.current.date(from: dateComponents)?.timeIntervalSince1970)
                UserDefaults.standard.set(Calendar.current.date(from: dateComponents)?.timeIntervalSince1970, forKey: "NextNoveltyTime")
            }
        }

    }
    
    static func delayNotification(bySeconds interval: TimeInterval = 60) {
        let content = UNMutableNotificationContent()
        content.title = "Your delayed novelty is here"
        content.body = "Tap to view today's challenge."
        content.sound = .default
        

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "dailyNovelty",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Scheduled notification in \(interval) seconds")
                UserDefaults.standard.set(Date().addingTimeInterval(interval).timeIntervalSince1970, forKey: "NextNoveltyTime")
            }
        }
    }
}

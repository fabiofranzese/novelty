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
    
    static func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Your novelty is here"
        content.body = "Tap to view today's challenge."
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .hour, .day, .minute], from: Date())
        dateComponents.day! += 1
        dateComponents.hour = Int.random(in: 9...22)
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
                print(Calendar.current.date(from: dateComponents)?.timeIntervalSince1970)
                UserDefaults.standard.set(Calendar.current.date(from: dateComponents)?.timeIntervalSince1970, forKey: "NextNoveltyTime")
            }
        }

    }
    
    static func delayNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Your delayed novelty is here"
        content.body = "Tap to view today's challenge."
        content.sound = .default
        var secs = secondsUntil0PM()
        if secs < 0 {
            scheduleDailyNotification()
            return
        }
        var seconds = Double.random(in: 0...secs)

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "dailyNovelty",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Scheduled notification in \(seconds) seconds")
                UserDefaults.standard.set(Date().addingTimeInterval(seconds).timeIntervalSince1970, forKey: "NextNoveltyTime")
            }
        }
    }
    static func secondsUntil0PM() -> TimeInterval {
        let calendar = Calendar.current
        let now = Date()
        
        // Create today's 10:00 PM
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 22
        components.minute = 0
        components.second = 0
        
        if let elevenPM = calendar.date(from: components) {
            let seconds = Double(elevenPM.timeIntervalSince(now))
            return max(0, seconds) // avoid negatives after 10 PM
        } else {
            return 0
        }
    }
}

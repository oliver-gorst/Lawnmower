//
//  NotificationManager.swift
//  Lawnmower
//
//  Created by Oliver Gorst on 4/25/26.
//

import UserNotifications
import Foundation

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notifications permitted")
            } else {
                print("Notifications denied")
            }
        }
    }

    func scheduleMowReminder(lastMowedTimestamp: Double) {
        // Cancel any existing mow reminders first
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["mowReminder"])

        guard lastMowedTimestamp > 0 else {
            // Never mowed — schedule for now + 7 days from install
            scheduleNotification(from: Date())
            return
        }

        let lastMowedDate = Date(timeIntervalSince1970: lastMowedTimestamp)
        scheduleNotification(from: lastMowedDate)
    }

    private func scheduleNotification(from date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Time to Mow 🌿"
        content.body = "It's been 7 days since your last mow. Your lawn is ready!"
        content.sound = .default

        // Schedule for 7 days after the given date
        guard let fireDate = Calendar.current.date(byAdding: .day, value: 7, to: date) else { return }

        // Only schedule if fire date is in the future
        guard fireDate > Date() else { return }

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: "mowReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
}

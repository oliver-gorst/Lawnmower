//
//  AppIntents.swift
//  Lawnmower
//
//  Created by Oliver Gorst on 4/25/26.
//
import AppIntents
import Foundation

struct LogMowIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Mow"
    static var description = IntentDescription("Log that you just mowed the lawn.")

    static var openAppWhenRun: Bool = false

    func perform() async throws -> some ProvidesDialog {
        let timestamp = Date().timeIntervalSince1970
        UserDefaults.standard.set(timestamp, forKey: "lastMowedDate")
        NotificationManager.shared.scheduleMowReminder(lastMowedTimestamp: timestamp)
        return .result(dialog: "Got it! I've logged your mow for today. 🌿")
    }
}

struct LawnmowerShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LogMowIntent(),
            phrases: [
                "I mowed in \(.applicationName)",
                "Log a mow in \(.applicationName)",
                "Record mow in \(.applicationName)",
                "I mowed in \(.applicationName)",
                "Just finished mowing in \(.applicationName)",
                "Mark lawn as mowed in \(.applicationName)",
                "Lawn is done in \(.applicationName)",
                "Finished the lawn in \(.applicationName)",
                "Done mowing in \(.applicationName)"
            ],
            shortTitle: "Log Mow",
            systemImageName: "leaf.fill"
        )
    }
}

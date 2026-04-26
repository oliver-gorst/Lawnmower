//
//  LawnmowerApp.swift
//  Lawnmower
//
//  Created by Oliver Gorst on 4/24/26.
//

import SwiftUI
import AppIntents

@main
struct LawnmowerApp: App {
    init() {
        NotificationManager.shared.requestPermission()
        LawnmowerShortcuts.updateAppShortcutParameters()
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}

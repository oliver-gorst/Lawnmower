//
//  AppSettings.swift
//  Lawnmower
//
//  Created by Oliver Gorst on 4/25/26.
//

import Foundation
import Combine

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @Published var useMetric: Bool {
        didSet {
            UserDefaults.standard.set(useMetric, forKey: "useMetric")
        }
    }
    
    init() {
        self.useMetric = UserDefaults.standard.bool(forKey: "useMetric")
    }
}

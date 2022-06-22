//
//  MTUserDefaults.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 22.06.22.
//

import Foundation

struct MTUserDefaults {
    static var shared = MTUserDefaults()
    
    var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .dark
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}

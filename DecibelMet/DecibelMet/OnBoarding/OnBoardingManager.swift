//
//  OnBoardingManager.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 15.05.22.
//

import Foundation

class OnboardingManager {
    
    static let shared = OnboardingManager()
    
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
}

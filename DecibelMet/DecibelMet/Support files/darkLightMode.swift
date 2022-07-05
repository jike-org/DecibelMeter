//
//  darkLightMode.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 22.06.22.
//

import Foundation
import AVFoundation
import UIKit

enum Theme: Int {
    case device
    case light
    case dark
    
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        
        switch self {
            
        case .device:
            return .dark
        case .light:
            return .light
        case .dark:
            return .dark
        }
        
    }
}

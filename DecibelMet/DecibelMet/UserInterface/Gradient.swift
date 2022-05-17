//
//  Gradient.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 4.05.22.
//

import Foundation
import UIKit

class Gradient {
    
    private let gradient: CAGradientLayer!
    
    public func setGradientBackground(view: UIView) {
        let backgroundLayer    = self.gradient
        backgroundLayer?.frame = CGRect(x: 0, y: 0, width: 2000, height: 66)
        
        view.layer.insertSublayer(backgroundLayer!, at: 0)
    }
    
    init() {
        let topColor    = #colorLiteral(red: 0, green: 0.5594989061, blue: 0.987998426, alpha: 1).cgColor
        let bottomColor = #colorLiteral(red: 0.1541146636, green: 0, blue: 0.9970051646, alpha: 1).cgColor
        
        self.gradient           = CAGradientLayer()
        self.gradient.colors    = [topColor, bottomColor]
        self.gradient.locations = [0.0, 1.0]
    }
    
}

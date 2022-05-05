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
        let topColor    = UIColor(named: "GradientTopColor")!.cgColor
        let bottomColor = UIColor(named: "GradientBottomColor")!.cgColor
        
        self.gradient           = CAGradientLayer()
        self.gradient.colors    = [topColor, bottomColor]
        self.gradient.locations = [0.0, 1.0]
    }
    
}

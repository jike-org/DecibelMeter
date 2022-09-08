//
//  Image.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 16.05.22.
//

import Foundation
import UIKit

class ImageView: UIImageView {
    
    enum Image {
        case lock
        case faq
        case rate
        case support
        case privacy
        case terms
        case share
        case chevron
        case nul
        case darkMode
        case refresh
    }
    
    init(image: Image) {
        super.init(frame: .zero)
        
        contentMode = .scaleAspectFit
        clipsToBounds = true
        
        switch image {
        case .lock:
            self.image = UIImage(named: "lock")
        case .faq:
            self.image = UIImage(named: "FAQ")
        case .rate:
            self.image = UIImage(named: "rate")
        case .support:
            self.image = UIImage(named: "support")
        case .privacy:
            self.image = UIImage(named: "privacy")
        case .terms:
            self.image = UIImage(named: "privacy")
        case .share:
            self.image = UIImage(named: "share")
        case .chevron:
            self.image = UIImage(named: "chevron")
        case .nul:
            print("null")
        case .darkMode:
            self.image = UIImage(named: "darkMode")
        case .refresh:
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 240, weight: .bold, scale: .medium)
            self.image = UIImage(systemName: "clock.arrow.2.circlepath")?.withTintColor(.blue).withConfiguration(largeConfig)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  Button.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 4.05.22.
//

import Foundation
import UIKit

class Button: UIButton {
    
    let gradient = Gradient()
    
    var uuid: UUID? = nil
    
    enum ButtonStyle {
        case _continue
        case link
        case record
        case close
        case playOrPause
    }
    
    public func setUUID(_ uuid: UUID) {
        self.uuid = uuid
    }
    
    init(style: ButtonStyle, _ text: String?) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        sizeToFit()
        
        switch style {
        case ._continue:
            setTitle(text, for: .normal)
            setTitleColor(.white, for: .normal)
            titleLabel?.font = titleLabel?.font.withSize(20)
            heightAnchor.constraint(equalToConstant: 60).isActive = true
            layer.cornerRadius = 12
            gradient.setGradientBackground(view: self)
            layer.masksToBounds = true
        case .link:
            setTitle(text, for: .normal)
            setTitleColor(.gray, for: .normal)
            titleLabel?.font = UIFont(name: "OpenSans-Regular", size: 12)!
        case .record:
            setImage(UIImage(named: "Microphone"), for: .normal)
            backgroundColor = UIColor(named: "RecordButtonColor")
            
            let radius: CGFloat
            let size: CGFloat
            
            if Constants().screenSize.height <= 568 {
                radius = 32.5
                size = 65
            } else {
                radius = 40
                size = 80
            }
            
            layer.cornerRadius = radius
            heightAnchor.constraint(equalToConstant: size).isActive = true
            widthAnchor.constraint(equalToConstant: size).isActive = true
        case .close:
            setImage(UIImage(named: "Exit"), for: .normal)
            heightAnchor.constraint(equalToConstant: 25).isActive = true
            widthAnchor.constraint(equalToConstant: 25).isActive = true
        case .playOrPause:
            setImage(UIImage(named: "Play"), for: .normal)
            heightAnchor.constraint(equalToConstant: 30).isActive = true
            widthAnchor.constraint(equalToConstant: 30).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

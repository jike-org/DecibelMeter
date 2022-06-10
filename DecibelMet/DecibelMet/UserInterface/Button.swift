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
    let radius: CGFloat = 100
    let size: CGFloat = 100
    var uuid: UUID? = nil
    
    enum ButtonStyle {
        case _continue
        case link
        case record
        case close
        case playOrPause
        case playOrPauseCell
        case refresh
        case noise
        case chevron
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
            titleLabel?.font = UIFont.systemFont(ofSize: 12)
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
            setImage(UIImage(named: "exit"), for: .normal)
            heightAnchor.constraint(equalToConstant: 25).isActive = true
            widthAnchor.constraint(equalToConstant: 25).isActive = true
        case .playOrPause:
            setImage(UIImage(named: "button3"), for: .normal)
            heightAnchor.constraint(equalToConstant: 30).isActive = true
            widthAnchor.constraint(equalToConstant: 30).isActive = true
            
        case .playOrPauseCell:
            setImage(UIImage(named: "png"), for: .normal)
            heightAnchor.constraint(equalToConstant: 50).isActive = true
            widthAnchor.constraint(equalToConstant: 50).isActive = true
        case .refresh:
            setImage(UIImage(named: "refresh"), for: .normal)
            backgroundColor = #colorLiteral(red: 0.979583323, green: 0.004220267292, blue: 1, alpha: 1)
            heightAnchor.constraint(equalToConstant: 50).isActive = true
            widthAnchor.constraint(equalToConstant: 50).isActive = true
            layer.cornerRadius = 20
        case .noise:
            backgroundColor = #colorLiteral(red: 0.1608400345, green: 0.1607262492, blue: 0.1650899053, alpha: 1)
            heightAnchor.constraint(equalToConstant: 50).isActive = true
            widthAnchor.constraint(equalToConstant: 100).isActive = true
            layer.cornerRadius = 20
            tintColor = .white
        case .chevron:
            setImage(UIImage(named: "chevron"), for: .normal)
            heightAnchor.constraint(equalToConstant: 20).isActive = true
            widthAnchor.constraint(equalToConstant: 20).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

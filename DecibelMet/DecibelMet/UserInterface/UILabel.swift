//
//  UILabel.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 4.05.22.
//

import Foundation
import UIKit

class Label: UILabel {
    
    enum LabelStyle {
        case heading
        case body
        case separator
        case decibelHeading
        case timeTitle
        case time
        case avgMinMax
        case avgMinMaxWord
        case tableLabel
        case titleLabel
        case tableTopText
        case tableBottomText
    }
    
    init(style: LabelStyle, _ text: String?) {
        super.init(frame: .zero)
        
        self.text     = text
        textColor     = .white
        numberOfLines = 1
        textAlignment = .center
        
        translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .heading:
            font = UIFont.systemFont(ofSize: 27)
        case .body:
            font = UIFont(name: "OpenSans-Regular", size: 15)
        case .separator:
            font = UIFont(name: "OpenSans-Regular", size: 12)
            self.text = "|"
        case .decibelHeading:
            font = UIFont.systemFont(ofSize: 43)
        case .timeTitle:
            font = UIFont.systemFont(ofSize: 10)
        case .time:
            font = UIFont.systemFont(ofSize: 10)
        case .avgMinMax:
            font = UIFont.systemFont(ofSize: 10)
        case .tableLabel:
            font = UIFont(name: "OpenSans-SemiBold", size: 15)
            textAlignment = .left
        case .titleLabel:
            font = UIFont(name: "OpenSans-SemiBold", size: 17)
        case .tableTopText:
            font = UIFont(name: "OpenSans-Regular", size: 14)
        case .tableBottomText:
            font = UIFont(name: "OpenSans-Regular", size: 10)
        case .avgMinMaxWord:
            font = UIFont.systemFont(ofSize: 25)
            textColor = .purple
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

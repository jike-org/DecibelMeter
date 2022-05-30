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
        case avg
        case cellDate
        case minMaxAvgCell
        case recordCell
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
            font = UIFont(name: "OpenSans-SemiBold", size: 17)
            textAlignment = .right
        case .titleLabel:
            font = UIFont(name: "OpenSans-SemiBold", size: 17)
            textAlignment = .left
        case .tableTopText:
            font = UIFont(name: "OpenSans-Regular", size: 20)
        case .tableBottomText:
            font = UIFont.systemFont(ofSize: 8)
        case .avgMinMaxWord:
            font = UIFont(name: "Montserrat-Light", size: 30.0)
            textColor = #colorLiteral(red: 0.979583323, green: 0.004220267292, blue: 1, alpha: 1)
        case .avg:
            font = UIFont.boldSystemFont(ofSize: 30)
            textColor = #colorLiteral(red: 0.979583323, green: 0.004220267292, blue: 1, alpha: 1)
        case .cellDate:
            font = UIFont.boldSystemFont(ofSize: 12)
            textAlignment = .right
        case .minMaxAvgCell:
            font = UIFont.systemFont(ofSize: 12)
            textAlignment = .left
            textColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
            layer.opacity = 0.7
        case .recordCell:
            font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

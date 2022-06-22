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
        case dosimeterHeader
        case dosimetreTime
        case dosimetreProcentLabel
        case dosimetreProcentImage
        case dosimetredb
        case dosimetreDecibelLabel
        case dbTitel
        case dbImage
        case subscribeSmall
    }
    
    init(style: LabelStyle, _ text: String?) {
        super.init(frame: .zero)
        
        self.text     = text
        textColor     = UIColor(named: "saveCell")
        numberOfLines = 1
        textAlignment = .center
//        tintColor = UIColor(named: "t")
        
        translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .heading:
            font = UIFont(name: "Montserrat-Bold", size: 24)
        case .body:
            font = UIFont(name: "OpenSans-Regular", size: 15)
        case .separator:
            font = UIFont(name: "OpenSans-Regular", size: 12)
            self.text = "|"
        case .decibelHeading:
            font = UIFont(name: "Montserrat-Medium", size: 40)
        case .timeTitle:
            font = UIFont.systemFont(ofSize: 10)
        case .time:
            font = UIFont(name: "Montserrat-Regular", size: 12)
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
            font = UIFont(name: "Montserrat-Bold", size: 30.0)
            textColor = #colorLiteral(red: 0.979583323, green: 0.004220267292, blue: 1, alpha: 1)
        case .cellDate:
            textColor = UIColor(named: "saveCell")
            font = UIFont(name: "Montserrat-Regular", size: 12)
            textAlignment = .right
        case .minMaxAvgCell:
            font = UIFont(name: "Montserrat-Regular", size: 12)
            textAlignment = .left
            layer.opacity = 0.7
        case .recordCell:
            font = UIFont(name: "Montserrat-SemiBold", size: 16.0)
        case .dosimeterHeader:
            font = UIFont.boldSystemFont(ofSize: 20)
        case .dosimetreTime:
            font = UIFont(name: "Montserrat-Regular", size: 16)
        case .dosimetreProcentLabel:
            font = UIFont(name: "Montserrat-Bold", size: 40)
        case .dosimetreProcentImage:
            font = UIFont.boldSystemFont(ofSize: 17)
        case .dosimetredb:
            font = UIFont.systemFont(ofSize: 13)
        case .dosimetreDecibelLabel:
            font = UIFont(name: "Montserrat-Regular", size: 20)
        case .dbTitel:
            font = UIFont(name: "Montserrat-SemiBold", size: 16.0)
        case .dbImage:
            font = UIFont.systemFont(ofSize: 10)
        case .subscribeSmall:
            font = UIFont(name: "Montserrat-Regular", size: 12.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

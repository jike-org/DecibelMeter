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
        case timeRecord
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
        case textFAQ
        case headingFAQ
        case likeLabel
        case onBoarding
        case textSub
        case acces
        case settingLabel
        case dbProcentImage
        case trial
        case camera
    }
    
    init(style: LabelStyle, _ text: String?) {
        super.init(frame: .zero)
        
        self.text     = text
        textColor     = UIColor(named: "saveCell")
        textAlignment = .left
        translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .heading:
            font = UIFont.systemFont(ofSize: 20, weight: .bold)
            textColor = UIColor(named: "cellDb")
        case .body:
            font = UIFont.systemFont(ofSize: 15, weight: .regular)
        case .separator:
            font = UIFont.systemFont(ofSize: 12, weight: .regular)
            self.text = "|"
        case .decibelHeading:
            font = UIFont.systemFont(ofSize: 40, weight: .medium)
            textColor = .white
        case .timeTitle:
            font = UIFont.systemFont(ofSize: 10)
        case .time:
            font = UIFont.systemFont(ofSize: 12, weight: .regular)
            textColor = UIColor(named: "cellDb")
        case .avgMinMax:
            font = UIFont.systemFont(ofSize: 10, weight: .light)
            textAlignment = .center
            if UserDefaults.standard.value(forKey: "theme") as! Int == 0 {
                textColor = .black
            }
            
            if UserDefaults.standard.value(forKey: "theme") as! Int == 1 {
                textColor = .white
            }
           
        case .tableLabel:
            font = UIFont.systemFont(ofSize: 20, weight: .regular)
            textAlignment = .left
        case .titleLabel:
            font = UIFont.boldSystemFont(ofSize: 20)
            textColor = UIColor(named: "cellDb")
            textAlignment = .left
        case .tableTopText:
            font = UIFont.systemFont(ofSize: 20, weight: .regular)
        case .tableBottomText:
            font = UIFont.systemFont(ofSize: 8)
        case .avgMinMaxWord:
            font = UIFont.systemFont(ofSize: 30, weight: .light)
            textColor = UIColor(named: "purple")
        case .avg:
            font = UIFont.systemFont(ofSize: 35, weight: .bold)
            textColor = UIColor(named: "purple")
        case .cellDate:
            textColor = UIColor(named: "cellDb")
            font = UIFont.systemFont(ofSize: 12, weight: .regular)
            textAlignment = .right
        case .minMaxAvgCell:
            font = UIFont.systemFont(ofSize: 12, weight: .regular)
            textAlignment = .left
            layer.opacity = 0.7
            textColor = UIColor(named: "cellDb")
        case .recordCell:
            font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            textColor = UIColor(named: "cellDb")
        case .dosimeterHeader:
            font = UIFont.boldSystemFont(ofSize: 20)
            textColor = UIColor(named: "cellDb")
        case .dosimetreTime:
            font = UIFont.systemFont(ofSize: 16, weight: .regular)
            textColor = UIColor(named: "cellDb")
        case .dosimetreProcentLabel:
            font = UIFont.systemFont(ofSize: 37, weight: .medium)
            textColor = UIColor(named: "cellDb")
        case .dosimetreProcentImage:
            font = UIFont.boldSystemFont(ofSize: 17)
            textColor = UIColor(named: "cellDb")
        case .dosimetredb:
            font = UIFont.systemFont(ofSize: 13)
            textColor = UIColor(named: "cellDb")
        case .dosimetreDecibelLabel:
            font = UIFont.systemFont(ofSize: 20, weight: .bold)
            textColor = UIColor(named: "cellDb")
        case .dbTitel:
            font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            textColor = UIColor(named: "cellDb")
        case .dbImage:
            font = UIFont.systemFont(ofSize: 10)
            textColor = UIColor(named: "cellDb")
        case .subscribeSmall:
            font = UIFont.systemFont(ofSize: 12, weight: .regular)
            textColor = UIColor(named: "cellDb")
        case .timeRecord:
            font = UIFont.systemFont(ofSize: 12, weight: .regular)
            textColor = .white
            textAlignment = .center
        case .textFAQ:
            numberOfLines = 0
            textColor = UIColor(named: "cellDb")
            font = UIFont.systemFont(ofSize: 16)
            textAlignment = .left
        case .headingFAQ:
            numberOfLines = 0
            textColor = UIColor(named: "cellDb")
            font = UIFont.systemFont(ofSize: 20, weight: .bold)
            textAlignment = .left
        case .likeLabel:
            font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            textAlignment = .center
            if Locale.current.languageCode! == "ja" {
                font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            }
        case .onBoarding:
            textColor = .white
            font = UIFont.systemFont(ofSize: 20, weight: .bold)
            numberOfLines = 0
            textAlignment = .center
        case .textSub:
            textColor = .white
            font = UIFont.systemFont(ofSize: 17, weight: .medium)
        case .acces:
            textColor = .white
            font = UIFont.systemFont(ofSize: 25, weight: .bold)
            numberOfLines = 0
            textAlignment = .center
        case .settingLabel:
            textColor = .red
            font = UIFont.systemFont(ofSize: 16.5, weight: .medium)
            
        case .dbProcentImage:
            font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            textColor = UIColor(named: "cellDb")
        case .trial:
            font = UIFont.systemFont(ofSize: 12, weight: .regular)
            numberOfLines = 0
            textColor = .white
            textAlignment = .center
        case .camera:
            font = UIFont.systemFont(ofSize: 13, weight: .medium)
            textColor = .white
            textAlignment = .left
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

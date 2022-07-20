//
//  SettingCell.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 5.05.22.
//

import Foundation
import UIKit


class SettingsCell: UITableViewCell {
    
    private var icon: ImageView?
    private var label: Label?
    public var _switch: UISwitch?
    private lazy var chevron = ImageView(image: .chevron)
    
    @objc private func toogleAutoRecord(_ sender: UISwitch) {
        if sender.isOn {
            window?.overrideUserInterfaceStyle = .dark
            print("dark")
        } else {
            window?.overrideUserInterfaceStyle = .light
            print("light")
        }
    }
    
    init(reuseIdentifier: String, icon: ImageView, label: Label, isUsingSwitch: Bool, chevron:ImageView ) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        _switch?.setOn(true, animated: true)
        _switch?.backgroundColor = .blue
        backgroundColor = .clear
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = UIColor(named: "BackgroundColorTabBar")
        selectedBackgroundView = selectedBackground
        
        self.chevron = chevron
        self.icon = icon
        self.label = label
        
        self.label?.textColor = UIColor(named: "cellDb")
        
        addSubview(self.icon!)
        addSubview(self.label!)
        addSubview(chevron)
        
        self.chevron.translatesAutoresizingMaskIntoConstraints = false
        self.icon!.translatesAutoresizingMaskIntoConstraints = false
        self.label!.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            self.icon!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            self.icon!.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.icon!.widthAnchor.constraint(equalToConstant: 20),
            self.icon!.heightAnchor.constraint(equalToConstant: 20),
            
            self.label!.leadingAnchor.constraint(equalTo: self.icon!.trailingAnchor, constant: 20),
            self.label!.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            self.chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            self.chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.chevron.widthAnchor.constraint(equalToConstant: 20),
            self.chevron.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        if isUsingSwitch {
            _switch = UISwitch()
            _switch!.tag = 1
            _switch?.setOn(true, animated: true)
            _switch?.isOn = true
            _switch?.onTintColor = .blue
            _switch!.addTarget(self, action: #selector(toogleAutoRecord(_:)), for: .valueChanged)
            
            accessoryView = _switch
            
//            if Constants().isRecordingAtLaunchEnabled {
//                _switch!.setOn(true, animated: true)
//            } else {
//                _switch!.setOn(false, animated: true)
//            }
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

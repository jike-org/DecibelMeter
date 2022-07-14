//
//  SubscribeOneView.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 16.05.22.
//

import Foundation
import Foundation
import StoreKit
import UIKit

class SubscribeViewController: UICollectionViewCell {
    
    let iapManager = InAppManager.share
    lazy var headingLabel = Label(style: .heading, "UNLOCK")
    lazy var headingLabelAll = Label(style: .heading, "ALL ACCESS")
    
    lazy var underLabel = Label(style: .subscribeSmall, "Start with a 7 day trial")

    public static let identifier = "SubscribeOne"
    
    lazy var backImage = UIImageView(image: UIImage(named: "04"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(backImage)
        addSubview(headingLabel)
        addSubview(headingLabelAll)
        addSubview(underLabel)
        backImage.frame = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headingLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 170),
            
            headingLabelAll.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10),
            headingLabelAll.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            underLabel.topAnchor.constraint(equalTo: headingLabelAll.bottomAnchor, constant: 20),
            underLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            ])
    }
}

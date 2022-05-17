//
//  SecondListView.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 16.05.22.
//

import Foundation
import Foundation
import UIKit

class SecondListViewController: UICollectionViewCell {
    
    lazy var headingLabel = Label(style: .heading, "DETECT SOUND")
    lazy var headingLabelLevel = Label(style: .heading, "LEVEL")
    public static let identifier = "SecondView"
    lazy var backImage = UIImageView(image: UIImage(named: "02"))
    
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
        addSubview(headingLabelLevel)
        NSLayoutConstraint.activate([
            backImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backImage.topAnchor.constraint(equalTo: topAnchor),
            backImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            headingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headingLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 170),
            headingLabelLevel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10),
            headingLabelLevel.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
}
//
//  ThirdListView.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 16.05.22.
//

import Foundation
import Foundation
import UIKit

class ThirdListViewController: UICollectionViewCell {

    lazy var headingLabel = Label(style: .heading, "MEASUREMENT")
    lazy var headingLabelHistory = Label(style: .heading, "HISTORY")
    public static let identifier = "ThirdView"
    
    lazy var backImage = UIImageView(image: UIImage(named: "03"))
    
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
        addSubview(headingLabelHistory)
        NSLayoutConstraint.activate([
            backImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backImage.topAnchor.constraint(equalTo: topAnchor),
            backImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            headingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headingLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 170),
            headingLabelHistory.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10),
            headingLabelHistory.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
}

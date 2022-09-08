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
    
    var lheading = NSLocalizedString("MeasurementHistory", comment: "")
    lazy var headingLabel = Label(style: .onBoarding, lheading.uppercased())
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
        backImage.frame = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headingLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 170),
        ])
    }
}

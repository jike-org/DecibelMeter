//
//  FirstListView.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 16.05.22.
//

import Foundation
import UIKit

class FirstListViewController: UICollectionViewCell {
    
    var lHeading = NSLocalizedString("SoundMeterDosimeter", comment: "")
    
    lazy var headingLabel = Label(style: .onBoarding, lHeading.uppercased())
//    lazy var headingLabelMeter = Label(style: .onBoarding, "METER")
    public static let identifier = "FirstView"
    lazy var backImage = UIImageView(image: UIImage(named: "01"))
    
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
//        addSubview(headingLabelMeter)
        backImage.frame = UIScreen.main.bounds
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headingLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 170),
//            headingLabelMeter.topAnchor.constraint(equalTo: headingLabel.bottomAnchor,constant: 10),
//            headingLabelMeter.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
}

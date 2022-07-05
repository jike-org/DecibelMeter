//
//  AvgMinMaxBar.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 4.05.22.
//

import Foundation
import UIKit

class AvgMinMaxBar: UIView {
    // MARK: Localizable
    var maxL = NSLocalizedString("Maximum", comment: "")
    var minL = NSLocalizedString("Minimum", comment: "")
    var avgL = NSLocalizedString("Average", comment: "")
    lazy var avgDecibelLabel = Label(style: .avg, "0")
    lazy var minDecibelLabel = Label(style: .avgMinMaxWord, "0")
    lazy var maxDecibelLabel = Label(style: .avgMinMaxWord, "0")

    lazy var avgLabel = Label(style: .avgMinMax, avgL)
    lazy var minLabel = Label(style: .avgMinMax, minL)
    lazy var maxLabel = Label(style: .avgMinMax, maxL)
    
    lazy var mainStack: UIStackView = {
        let s = UIStackView()
        
        s.axis         = .horizontal
        s.alignment    = .fill
        s.distribution = .fillProportionally
        s.spacing      = 100
        
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
    }()
    
    lazy var avgStack = StackView(axis: .vertical)
    lazy var minStack = StackView(axis: .vertical)
    lazy var maxStack = StackView(axis: .vertical)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        avgDecibelLabel.translatesAutoresizingMaskIntoConstraints = true
        minDecibelLabel.translatesAutoresizingMaskIntoConstraints = true
        maxDecibelLabel.translatesAutoresizingMaskIntoConstraints = true
        avgLabel.translatesAutoresizingMaskIntoConstraints = false
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        avgStack.translatesAutoresizingMaskIntoConstraints = false
        minStack.translatesAutoresizingMaskIntoConstraints = false
        maxStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        
        mainStack.addArrangedSubview(avgStack)
        mainStack.addArrangedSubview(minStack)
        mainStack.addArrangedSubview(maxStack)
        
        avgStack.addArrangedSubview(avgDecibelLabel)
        avgStack.addArrangedSubview(avgLabel)
        
        minStack.addArrangedSubview(minDecibelLabel)
        minStack.addArrangedSubview(minLabel)
        
        maxStack.addArrangedSubview(maxDecibelLabel)
        maxStack.addArrangedSubview(maxLabel)
        
        let constraints = [
            heightAnchor.constraint(equalTo: mainStack.heightAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  SubscribeOneView.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 16.05.22.
//

import Foundation
import StoreKit
import UIKit
import FirebaseRemoteConfig

class SubscribeViewController: UICollectionViewCell {
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    private var textDelay: Int = 10
    var lTrial = NSLocalizedString("Start7Day", comment: "")
    var lTrialThen = NSLocalizedString("Trial7", comment: "")
    var lHeading = NSLocalizedString("UnlockAllAccess", comment: "")
    let notificationCenter = NotificationCenter.default
    let iapManager = InAppManager.share
    lazy var headingLabel = Label(style: .onBoarding, lHeading.uppercased())
    lazy var spinenr = UIActivityIndicatorView(style: .large)
    
    lazy var trialButton = Label(style: .trial, "")

    public static let identifier = "SubscribeOne"
    
    lazy var backImage = UIImageView(image: UIImage(named: "04"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        func fetchValues() {
        
            let setting = RemoteConfigSettings()
            setting.minimumFetchInterval = 0
            remoteConfig.configSettings = setting
        }
        
        remoteConfig.fetchAndActivate { (status, error) in
            
            if error !=  nil {
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["textSubscriptionDelay"].stringValue {
                        self.textDelay = Int(stringValue)!
                    }
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        trialButton.isHidden = true
        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(textDelay), repeats: false, block: { Timer in
            self.trialButton.isHidden = false
        })
        addSubview(backImage)
        addSubview(headingLabel)
        addSubview(trialButton)
        backImage.frame = UIScreen.main.bounds
        backImage.addSubview(spinenr)
        spinenr.translatesAutoresizingMaskIntoConstraints = false
        spinenr.centerXAnchor.constraint(equalTo: backImage.centerXAnchor).isActive = true
        spinenr.centerYAnchor.constraint(equalTo: backImage.centerYAnchor).isActive = true
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headingLabel.bottomAnchor.constraint(equalTo: trialButton.topAnchor, constant: -30),

            trialButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -180),
            trialButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trialButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            trialButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    private func priceStringFor(product: SKProduct) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        
        return numberFormatter.string(from: product.price)!
    }
}



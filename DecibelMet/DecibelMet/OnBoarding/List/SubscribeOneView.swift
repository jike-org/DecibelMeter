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
    let product = InAppManager.share.product
    lazy var spinenr = UIActivityIndicatorView(style: .large)
    
    lazy var trialButton = Button(style: .trial, "\(lTrial) \(priceStringFor(product: product[3])) \(lTrialThen)")

    public static let identifier = "SubscribeOne"
    
    lazy var backImage = UIImageView(image: UIImage(named: "04"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        notificationCenter.addObserver(self, selector: #selector(trialButtonTapped1), name: NSNotification.Name(InAppPurchaseProduct.weekTrial.rawValue), object: nil)
        
        func fetchValues() {
        
            let setting = RemoteConfigSettings()
            setting.minimumFetchInterval = 0
            remoteConfig.configSettings = setting
        }
        
        remoteConfig.fetchAndActivate { (status, error) in
            
            if error !=  nil {
                print(error?.localizedDescription)
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["textSubscriptionDelay"].stringValue {
                        print (stringValue)
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
        trialButton.addTarget(self, action: #selector(trialButtonTapped), for: .touchUpInside)
        addSubview(backImage)
        addSubview(headingLabel)
//        addSubview(headingLabelAll)
        addSubview(trialButton)
        backImage.frame = UIScreen.main.bounds
        backImage.addSubview(spinenr)
        spinenr.translatesAutoresizingMaskIntoConstraints = false
        spinenr.centerXAnchor.constraint(equalTo: backImage.centerXAnchor).isActive = true
        spinenr.centerYAnchor.constraint(equalTo: backImage.centerYAnchor).isActive = true
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            headingLabel.bottomAnchor.constraint(equalTo: trialButton.topAnchor, constant: -30),
            
//            headingLabelAll.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10),
//            headingLabelAll.centerXAnchor.constraint(equalTo: centerXAnchor),
            
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
        
        print(numberFormatter.string(from: product.price)!)
        return numberFormatter.string(from: product.price)!
    }
    
    @objc func trialButtonTapped() {
    }
    
    @objc func trialButtonTapped1() {
        print("купил")
        Constants.shared.hasPurchased = true
        
    }
}



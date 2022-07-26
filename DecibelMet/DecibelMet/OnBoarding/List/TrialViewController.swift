//
//  TrialViewController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 25.07.22.
//

import Foundation
import UIKit
import StoreKit
import FirebaseRemoteConfig

class TrialViewController: UIViewController {
    
    let iapManager = InAppManager.share
    let remoteConfig = RemoteConfig.remoteConfig()
    let product = InAppManager.share.product
    var xMarkDelay = 5
    var textDelay = 5
    
    //MARK: - Localizable
    var lTrial = NSLocalizedString("Start7Day", comment: "")
    var lTrialThen = NSLocalizedString("Trial7", comment: "")
    var lHeading = NSLocalizedString("UnlockAllAccess", comment: "")
    var lRestore = NSLocalizedString("Restore", comment: "")
    let lprivacy = NSLocalizedString("PrivacyPolice", comment: "")
    let land = NSLocalizedString("and", comment: "")
    let lterms = NSLocalizedString("TermsOfService", comment: "")
    let lContinue = NSLocalizedString("Continue", comment: "")
    
    //MARK: - Create UI
    lazy var restore = Button(style: .trial, lRestore)
    lazy var xMark = Button(style: .close, "X")
    lazy var headingLabel = Label(style: .onBoarding, lHeading.uppercased())
    lazy var startTrial = Label(style: .trial, "\(lTrial) ,\n\(priceStringFor(product: product[3])) \(lTrialThen)")
    lazy var continueButton = Button(style: ._continue, lContinue)
    lazy var terms = Button(style: .trial, lterms)
    lazy var privacy = Button(style: .trial, lprivacy)
    lazy var andLabel = Label(style: .trial, land)
    lazy var hStack = StackView(axis: .horizontal)
    lazy var bcImage = UIImageView(image: UIImage(named: "04"))
    lazy var spiner = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        remoteConfigSetup()
    }
}

extension TrialViewController {
    
    func setup() {
        
        bcImage.frame = UIScreen.main.bounds
        view.addSubview(bcImage)
        view.addSubview(restore)
        view.addSubview(xMark)
        view.addSubview(headingLabel)
        view.addSubview(startTrial)
        view.addSubview(continueButton)
        view.addSubview(hStack)
        view.addSubview(spiner)
        
        spiner.translatesAutoresizingMaskIntoConstraints = false
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        hStack.addArrangedSubview(terms)
        hStack.addArrangedSubview(andLabel)
        hStack.addArrangedSubview(privacy)
        
        startTrial.isHidden = true
        xMark.isHidden = true
        hStack.spacing = 7
        privacy.setTitleColor(.systemBlue, for: .normal)
        terms.setTitleColor(.systemBlue, for: .normal)
        
        xMark.addTarget(self, action: #selector(xMarkTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        terms.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        privacy.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            restore.topAnchor.constraint(equalTo: bcImage.safeAreaLayoutGuide.topAnchor),
            restore.leadingAnchor.constraint(equalTo: bcImage.leadingAnchor, constant: 20),
            restore.widthAnchor.constraint(equalToConstant: 120),
            restore.heightAnchor.constraint(equalToConstant: 20),
            
            xMark.topAnchor.constraint(equalTo: bcImage.safeAreaLayoutGuide.topAnchor),
            xMark.trailingAnchor.constraint(equalTo: bcImage.trailingAnchor, constant: -20),
            xMark.widthAnchor.constraint(equalToConstant: 60),
            xMark.heightAnchor.constraint(equalToConstant: 30),
            
            hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hStack.heightAnchor.constraint(equalToConstant: 30),
            
            continueButton.bottomAnchor.constraint(equalTo: hStack.topAnchor, constant: -30),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startTrial.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -30),
            startTrial.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startTrial.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            headingLabel.bottomAnchor.constraint(equalTo: startTrial.topAnchor, constant: -30),
            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            spiner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spiner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func remoteConfigSetup() {
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
        
        remoteConfig.fetchAndActivate { (status, error) in
            
            if error !=  nil {
                print(error?.localizedDescription)
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["closeButtonDelay"].stringValue {
                        print (stringValue)
                        self.xMarkDelay = Int(stringValue)!
                    }
                }
            }
            
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

        
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(xMarkDelay), repeats: false) { [self] Timer in
            xMark.isHidden = false
        }
        
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(textDelay), repeats: false) { [self] Timer in
            startTrial.isHidden = false
        }
    }
    
}

extension TrialViewController {
    
    @objc func termsTapped() {
        let url = URL(string: "https://www.mindateq.io/terms-of-use")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func xMarkTapped() {
        let vc = TabBar()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func privacyTapped() {
        let url = URL(string: "https://www.mindateq.io/privacy-policy")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func continueTapped() {
        iapManager.purchase(productWith: "com.decibelmeter.1wetr")
        spiner.startAnimating()
        let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
            spiner.stopAnimating()
        }
        
    }
    @objc func restoreTapped() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func priceStringFor(product: SKProduct) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        
        print(numberFormatter.string(from: product.price)!)
        return numberFormatter.string(from: product.price)!
    }
    
    
}

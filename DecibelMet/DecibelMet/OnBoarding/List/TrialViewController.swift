//
//  TrialViewController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 25.07.22.
//

//  3 экран

import Foundation
import UIKit
import StoreKit
import SwiftyStoreKit
import FirebaseRemoteConfig

class TrialViewController: UIViewController {
    
    let iapManager = IAPManager.shared
    let remoteConfig = RemoteConfig.remoteConfig()
    var xMarkDelay = 0
    var textDelay = 0
    var sub = "com.decibelmeter.1wetr"
    
    let productW = InAppManager.share.productW
    let productM = InAppManager.share.productM
    let productY = InAppManager.share.productY
    let productWT = InAppManager.share.productWT
    let productMT = InAppManager.share.productMT
    let productYT = InAppManager.share.productYT

    
    //MARK: - Localizable
    var lTrial = NSLocalizedString("Start7Day", comment: "")
    var lTrialThen = NSLocalizedString("Trial7", comment: "")
    var lHeading = NSLocalizedString("UnlockAllAccess", comment: "")
    var lRestore = NSLocalizedString("Restore", comment: "")
    let lprivacy = NSLocalizedString("PrivacyPolice", comment: "")
    let land = NSLocalizedString("and", comment: "")
    let lterms = NSLocalizedString("TermsOfService", comment: "")
    let lContinue = NSLocalizedString("Continue", comment: "")
    let tTrial = NSLocalizedString("Start7Day", comment: "")
    let lthen = NSLocalizedString("trialText", comment: "")
    let lweekPer  = NSLocalizedString("perWeek", comment: "")
    let small = NSLocalizedString("perWeekSmall", comment: "")
    let lMounth = NSLocalizedString("perMounth", comment: "")
    let lYear = NSLocalizedString("perYear", comment: "")
  
    let smallYear = NSLocalizedString("perYearSmall", comment: "")
    let smallMounth = NSLocalizedString("perMounthSmall", comment: "")
    //MARK: - Create UI
    lazy var restore = Button(style: .trial, lRestore)
    lazy var xMark = Button(style: .close, "X")
    lazy var headingLabel = Label(style: .onBoarding, lHeading.uppercased())
    lazy var startTrial = Label(style: .trial, "")
    lazy var continueButton = Button(style: ._continue, lContinue)
    lazy var terms = Button(style: .trial, lterms)
    lazy var privacy = Button(style: .trial, lprivacy)
    lazy var andLabel = Label(style: .trial, land)
    lazy var hStack = StackView(axis: .horizontal)
    lazy var bcImage = UIImageView(image: UIImage(named: "04"))
    lazy var spiner = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
       
        remoteConfigSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
}

extension TrialViewController {
    
    func setup() {
        
        if UserDefaults.standard.value(forKey: "theme") == nil {
            let one = 1
            UserDefaults.standard.set(one, forKey: "theme")
        }
        
        if UserDefaults.standard.value(forKey: "theme") as! Int == 1 {
            bcImage.image = UIImage(named: "04")
            privacy.setTitleColor(.systemBlue, for: .normal)
            terms.setTitleColor(.systemBlue, for: .normal)
        }
        
        if UserDefaults.standard.value(forKey: "theme") as! Int == 0 {
            bcImage.image = UIImage(named: "08")
            privacy.setTitleColor(.white, for: .normal)
            terms.setTitleColor(.white, for: .normal)
            andLabel.textColor = .white
        }
        
        var t = ""
        if Constants.shared.isFirstLaunch == true {
            if let stringValue =
                self.remoteConfig["otherSubscription"].stringValue {
                t = String(stringValue)
            }
        } else {
            if let stringValue =
                self.remoteConfig["welcomeTourSubscription"].stringValue {
                t = String(stringValue)
            }
        }
       
        if t == "com.decibelmeter.1wetr" {
            if  Locale.current.languageCode! == "tr"{
                let q = DispatchQueue.global(qos: .userInteractive)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1wetr"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lthen)  \(priceString) \(lweekPer)"

                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            } else if  Locale.current.languageCode! == "ko" {
                
                let q = DispatchQueue.global(qos: .userInteractive)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1wetr"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text =  "\(lthen) \(priceString) \(lweekPer)"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            }
                else {
               
            }
        } else if  t == "com.decibelmeter.1we" {
            
            if  Locale.current.languageCode! == "tr" {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1we"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lweekPer) \(priceString) \(NSLocalizedString("SubFor", comment: ""))"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            } else if   Locale.current.languageCode! == "ja" {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1we"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = " \(priceString) \(lweekPer) \(NSLocalizedString("SubFor", comment: ""))"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            } else if Locale.current.languageCode! == "ko" {
                let q = DispatchQueue.global(qos: .userInteractive)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1we"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lweekPer) \(priceString) \(NSLocalizedString("SubFor", comment: ""))"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            }
              else {
                  let q = DispatchQueue.global(qos: .default)
                  q.async {
                      [self] in
                      SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1we"]) { [self] result in
                          if let product = result.retrievedProducts.first {
                              let priceString = product.localizedPrice!
                              startTrial.text = " \(NSLocalizedString("SubFor", comment: "")) \(priceString) \(lweekPer)"
                          }
                          else if let invalidProductId = result.invalidProductIDs.first {
                          }
                          else {
                          }
                      }

                  }
            }
         
        } else if t == "com.decibelmeter.1mo" {
            if  Locale.current.languageCode! == "tr" {
              
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1mo"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lMounth) \(priceString) \(NSLocalizedString("SubFor", comment: ""))"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            } else if   Locale.current.languageCode! == "ja" {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1mo"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = " \(priceString) \(lMounth) \(NSLocalizedString("SubFor", comment: ""))"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            } else if  Locale.current.languageCode! == "ko" {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1mo"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lMounth) \(priceString) \(NSLocalizedString("SubFor", comment: ""))"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            }
            else {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1mo"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = " \(NSLocalizedString("SubFor", comment: "")) \(priceString) \(lMounth)"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            }
            
        } else if t == "com.decibelmeter.1ye" {
            
            if   Locale.current.languageCode! == "tr" {
              
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1ye"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lYear) \(priceString) \(NSLocalizedString("SubFor", comment: ""))"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            } else if   Locale.current.languageCode! == "ja" {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1ye"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = " \(priceString) \(lYear) \(NSLocalizedString("SubFor", comment: ""))"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            } else if Locale.current.languageCode! == "ko" {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1ye"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lYear) \(priceString) \(NSLocalizedString("SubFor", comment: ""))"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            }
            
            else {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1ye"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = " \(NSLocalizedString("SubFor", comment: "")) \(priceString) \(lYear)"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            }
        } else if t == "com.decibelmeter.1yetr" {
            if  Locale.current.languageCode! == "tr"{
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1yetr"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lthen) \(smallYear) \(priceString) ödeyin "
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            } else if  Locale.current.languageCode! == "ko" {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1yetr"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lthen)  \(priceString) \(lYear) "
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            }
            
            else {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1yetr"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text =  "\(lthen) \(priceString) \(lYear)"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            }
        } else if t == "com.decibelmeter.1motr" {
            if  Locale.current.languageCode! == "tr"{
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1motr"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lthen) \(smallMounth) \(priceString) ödeyin "
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            } else if  Locale.current.languageCode! == "ko" {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1motr"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text = "\(lthen)  \(priceString) \(lMounth) "
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            }
            
            else {
                let q = DispatchQueue.global(qos: .default)
                q.async {
                    [self] in
                    SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1motr"]) { [self] result in
                        if let product = result.retrievedProducts.first {
                            let priceString = product.localizedPrice!
                            startTrial.text =  "\(lthen) \(priceString) \(lMounth)"
                        }
                        else if let invalidProductId = result.invalidProductIDs.first {
                        }
                        else {
                        }
                    }

                }
            }
        } else {
            let vc = TrialSubscribe()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        
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
        
        xMark.addTarget(self, action: #selector(xMarkTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        terms.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        privacy.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
        restore.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        
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
            startTrial.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            startTrial.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            headingLabel.bottomAnchor.constraint(equalTo: startTrial.topAnchor, constant: -75),
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
        
        remoteConfig.fetchAndActivate { [self] (status, error) in
            
            if error !=  nil {
              
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["closeButtonDelay"].stringValue {
                        self.xMarkDelay = Int(stringValue)!
                        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(xMarkDelay), repeats: false) { [self] Timer in
                            xMark.isHidden = false
                        }
                    }
                }
            }
            
            if error !=  nil {
                
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["textSubscriptionDelay"].stringValue {
                        self.textDelay = Int(stringValue)!
                        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(textDelay), repeats: false) { [self] Timer in
                            startTrial.isHidden = false
                        }
                    }
                }
            }
            
            if error !=  nil {
               
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["welcomeTourSubscription"].stringValue {
                        self.sub = stringValue
                    }
                }
            }
        }
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            xMarkDelay = 0
            textDelay = 0
            let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(textDelay), repeats: false) { [self] Timer in
                startTrial.isHidden = false
            }
            let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(xMarkDelay), repeats: false) { [self] Timer in
                xMark.isHidden = false
            }
        }
    }
}

extension TrialViewController {
    
    @objc func termsTapped() {
        let url = URL(string: "https://www.mindateq.io/terms-of-use")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func xMarkTapped() {
       if Constants.shared.isFirstLaunch == false {
            let vc = TabBar()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
           Constants.shared.isFirstLaunch = true
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc func privacyTapped() {
        let url = URL(string: "https://www.mindateq.io/privacy-policy")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func continueTapped() {
        
        var t = ""
        if Constants.shared.isFirstLaunch == true {
            if let stringValue =
                self.remoteConfig["otherSubscription"].stringValue {
                t = String(stringValue)
            }
        } else {
            if let stringValue =
                self.remoteConfig["welcomeTourSubscription"].stringValue {
                t = String(stringValue)
            }
        }
   
        if t == "com.decibelmeter.1wetr" {
            iapManager.purchase(purchase: .weekTrial)
            spiner.startAnimating()
            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
                spiner.stopAnimating()
            }
        } else if  t == "com.decibelmeter.1we" {
            iapManager.purchase(purchase: .week)
            
            spiner.startAnimating()
            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
                spiner.stopAnimating()
            }
        } else if t == "com.decibelmeter.1mo" {
            iapManager.purchase(purchase: .mounth)
           
            spiner.startAnimating()
            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
                spiner.stopAnimating()
            }
        } else if t == "com.decibelmeter.1ye" {
            iapManager.purchase(purchase: .year)
            spiner.startAnimating()
            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
                spiner.stopAnimating()
            }
        } else if t == "com.decibelmeter.1yetr" {
            iapManager.purchase(purchase: .yearTrial)
            spiner.startAnimating()
            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
                spiner.stopAnimating()
            }
        } else if t == "com.decibelmeter.1motr" {
            iapManager.purchase(purchase: .mounthTrial)
            spiner.startAnimating()
            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
                spiner.stopAnimating()
            }
        }
    }
    
    @objc func restoreTapped() {
        
        let alertController = UIAlertController(title:NSLocalizedString("DecibelMeter", comment: "")  , message: NSLocalizedString("subNO", comment: ""), preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
        
        alertController.addAction(cancelButton)
        
        let alertController2 = UIAlertController(title: NSLocalizedString("DecibelMeter", comment: ""), message: NSLocalizedString("subYES", comment: ""), preferredStyle: .alert)
        
        let cancelButton2 = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
        
        alertController2.addAction(cancelButton2)
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {

            }
            else if results.restoredPurchases.count > 0 {
                let accesss = true
                UserDefaults.standard.set(accesss, forKey: "FullAccess")
                self.present(alertController2, animated: true, completion: nil)
                let _ = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { Timer in
                    self.dismiss(animated: true)
                }
            }
            else {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        IAPManager.shared.restorePurchases()
        
    }
    
    private func priceStringFor(product: SKProduct) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        
        return numberFormatter.string(from: product.price)!
    }
}

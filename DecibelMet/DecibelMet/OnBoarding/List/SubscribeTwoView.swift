//
//  SubscribeTwoView.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 16.05.22.
//

// 2 экран

import Foundation
import UIKit
import StoreKit
import SwiftyStoreKit
import FirebaseRemoteConfig

class SubscribeTwoView: UIViewController {
    
    var remoteConfig = RemoteConfig.remoteConfig()
    let notificationCenter = NotificationCenter.default
    let iapManager = InAppManager.share
    let lprivacy = NSLocalizedString("PrivacyPolice", comment: "")
    let lrestore = NSLocalizedString("Restore", comment: "")
    let lterms = NSLocalizedString("TermsOfService", comment: "")
    let unlimitedRecord = NSLocalizedString("Unlimitedrecording", comment: "")
    let unlimitedAccess = NSLocalizedString("Unlimitedaccess", comment: "")
    let unlimitedPhoto = NSLocalizedString("Unlimitedphotoandvideo", comment: "")
    let land = NSLocalizedString("and", comment: "")
    let lweek = NSLocalizedString("Week", comment: "")
    let lmounth = NSLocalizedString("Month", comment: "")
    let lyear = NSLocalizedString("Year", comment: "")
    let lAcces = NSLocalizedString("UnlockAllAccess", comment: "")
    
    let tTrial = NSLocalizedString("Start7Day", comment: "")
    let lthen = NSLocalizedString("then", comment: "")
    let lweekPer  = NSLocalizedString("perWeek", comment: "")
    
    var xMarkDelay = 0
    var textDelay = 0
    lazy var backgroundViewImage = UIImageView(image: UIImage(named: "04"))
    lazy var hStack = StackView(axis: .horizontal)
    lazy var privacy = Button(style: .subscriptionVC, lprivacy)
    lazy var restore = Button(style: .restoreButton, lrestore)
    lazy var terms = Button(style: .subscriptionVC, lterms)
    lazy var andLabel = Label(style: .time, land)
    lazy var xMark = Button(style: .close, "X")
    lazy var spinenr = UIActivityIndicatorView(style: .large)
    lazy var subText = Label(style: .textSub, "")
    lazy var subText1 = Label(style: .textSub, "")
    lazy var subText2 = Label(style: .textSub, "")
    lazy var acces = Label(style: .acces, lAcces.uppercased())
    
    lazy var textView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let productW = InAppManager.share.productW
    let productM = InAppManager.share.productM
    let productY = InAppManager.share.productY
    
    lazy var weekSubscribe = Button(style: ._continue, "")
    lazy var mounthSubscribe = Button(style: ._continue, "")
    lazy var yearSubscribe = Button(style: ._continue, "")
    lazy var unlimited = Label(style: .timeTitle, "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        remoteConfigSetup()
        
        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(xMarkDelay), repeats: false) { [self] Timer in
            xMark.isHidden = false
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
                            self.textDelay = Int(stringValue) ?? 0
                            
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.value(forKey: "theme") == nil {
            let one = 1
            UserDefaults.standard.set(one, forKey: "theme")
        }
        
        if UserDefaults.standard.value(forKey: "theme") as! Int == 1 {
            backgroundViewImage.image = UIImage(named: "04")
            privacy.setTitleColor(.systemBlue, for: .normal)
            terms.setTitleColor(.systemBlue, for: .normal)
        }
        
        if UserDefaults.standard.value(forKey: "theme") as! Int == 0 {
            backgroundViewImage.image = UIImage(named: "08")
            privacy.setTitleColor(.white, for: .normal)
            terms.setTitleColor(.white, for: .normal)
            andLabel.textColor = .white
        }
        
        if Reachability.isConnectedToNetwork(){
            
            let queue = DispatchQueue.global()
            queue.async{ [self] in
                
                SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1we"]) { [self] result in
                    if let product = result.retrievedProducts.first {
                        let priceString = product.localizedPrice!
                        print("Product: \(product.localizedDescription), price: \(priceString)")
                        weekSubscribe.setTitle("\(priceString) / \(lweek)", for: .normal)

                    }
                    else if let invalidProductId = result.invalidProductIDs.first {
                    }
                    else {
                    }
                }
                
                SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1mo"]) { [self] result in
                    if let product = result.retrievedProducts.first {
                        let priceString = product.localizedPrice!
                        mounthSubscribe.setTitle("\(priceString) / \(lmounth)", for: .normal)

                    }
                    else if let invalidProductId = result.invalidProductIDs.first {
                    }
                    else {
                    }
                }
                
                SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1ye"]) { [self] result in
                    if let product = result.retrievedProducts.first {
                        let priceString = product.localizedPrice!
                        yearSubscribe.setTitle("\(priceString) / \(lyear)", for: .normal)

                    }
                    else if let invalidProductId = result.invalidProductIDs.first {
                    }
                    else {
                    }
                }
            }
            
       
        } else {
            weekSubscribe.setTitle("$3.99 / \(lweek)", for: .normal)
            mounthSubscribe.setTitle("$6.99 / \(lmounth)", for: .normal)
            yearSubscribe.setTitle("$9.99 / \(lyear)", for: .normal)
        }
    }
    
    private func priceStringFor(product: SKProduct) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        
        return numberFormatter.string(from: product.price) ?? "??"
    }
}

extension SubscribeTwoView {
    
    func setup() {
        
        xMark.isHidden = true
        if let stringValue =
            self.remoteConfig["closeButtonDelay"].stringValue {
            self.xMarkDelay = Int(stringValue) ?? 0
        }
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "circle.fill")
        imageAttachment.image = UIImage(systemName: "circle.fill")?.withTintColor(.white)
        imageAttachment.setImageHeight(height: 7)
        
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        fullString.append(NSAttributedString(string: " " + unlimitedRecord))
        
        let fullString1 = NSMutableAttributedString(attachment: imageAttachment)
        fullString1.append(NSAttributedString(string: " " + unlimitedAccess))
        
        let fullString2 = NSMutableAttributedString(attachment: imageAttachment)
        fullString2.append(NSAttributedString(string: " " + unlimitedPhoto))
        
        subText.attributedText = fullString
        subText1.attributedText = fullString1
        subText2.attributedText = fullString2
        
        andLabel.tintColor = .white
        view.backgroundColor = .clear
        backgroundViewImage.addSubview(spinenr)
        
        spinenr.translatesAutoresizingMaskIntoConstraints = false
        spinenr.centerXAnchor.constraint(equalTo: backgroundViewImage.centerXAnchor).isActive = true
        spinenr.centerYAnchor.constraint(equalTo: backgroundViewImage.centerYAnchor).isActive = true
        
        backgroundViewImage.addSubview(textView)
        textView.addSubview(subText)
        textView.addSubview(subText1)
        textView.addSubview(subText2)
        
        backgroundViewImage.addSubview(acces)
        view.addSubview(backgroundViewImage)
        view.addSubview(hStack)
        view.addSubview(restore)
        view.addSubview(xMark)
        view.addSubview(weekSubscribe)
        view.addSubview(mounthSubscribe)
        view.addSubview(yearSubscribe)
        
        yearSubscribe.addTarget(self, action: #selector(yearSub), for: .touchUpInside)
        mounthSubscribe.addTarget(self, action: #selector(mounthSub), for: .touchUpInside)
        weekSubscribe.addTarget(self, action: #selector(weekSub), for: .touchUpInside)
        xMark.addTarget(self, action: #selector(xMarkCloseVC), for: .touchUpInside)
        restore.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        privacy.addTarget(self, action: #selector(privacyTap), for: .touchUpInside)
        terms.addTarget(self, action: #selector(termsTap), for: .touchUpInside)
        
        hStack.spacing = 10
        backgroundViewImage.frame = UIScreen.main.bounds
        hStack.translatesAutoresizingMaskIntoConstraints = false
        yearSubscribe.translatesAutoresizingMaskIntoConstraints = false
        mounthSubscribe.translatesAutoresizingMaskIntoConstraints = false
        weekSubscribe.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        hStack.addArrangedSubview(terms)
        hStack.addArrangedSubview(andLabel)
        hStack.addArrangedSubview(privacy)
        
        terms.setTitleColor(.systemBlue, for: .normal)
        privacy.setTitleColor(.systemBlue, for: .normal)
        NSLayoutConstraint.activate([
            restore.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            restore.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            xMark.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            xMark.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            yearSubscribe.bottomAnchor.constraint(equalTo: hStack.topAnchor,constant: -30),
            yearSubscribe.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            yearSubscribe.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            yearSubscribe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            mounthSubscribe.bottomAnchor.constraint(equalTo: yearSubscribe.topAnchor,constant: -20),
            mounthSubscribe.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mounthSubscribe.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mounthSubscribe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            weekSubscribe.bottomAnchor.constraint(equalTo: mounthSubscribe.topAnchor,constant: -20),
            weekSubscribe.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weekSubscribe.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weekSubscribe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            textView.bottomAnchor.constraint(equalTo: weekSubscribe.topAnchor, constant: -50),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 100),
            
            acces.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -45),
            acces.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subText.topAnchor.constraint(equalTo: textView.topAnchor),
            subText.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            
            subText1.topAnchor.constraint(equalTo: subText.bottomAnchor, constant: 10),
            subText1.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            
            subText2.topAnchor.constraint(equalTo: subText1.bottomAnchor, constant: 10),
            subText2.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            
        ])
    }
}

extension SubscribeTwoView {
    
    @objc func privacyTap() {
        if let url = URL(string: "https://www.mindateq.io/privacy-policy") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func termsTap() {
        if let url = URL(string: "https://www.mindateq.io/terms-of-use") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func yearSub() {
        IAPManager.shared.purchase(purchase: .year)
        DispatchQueue.main.async {
            self.spinenr.startAnimating()
            _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { Timer in
                self.spinenr.stopAnimating()
            })
        }
    }
    
    @objc func mounthSub() {
        IAPManager.shared.purchase(purchase: .mounth)
        DispatchQueue.main.async {
            self.spinenr.startAnimating()
            _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { Timer in
                self.spinenr.stopAnimating()
            })
        }
    }
    
    @objc func weekSub() {
        IAPManager.shared.purchase(purchase: .week)
        DispatchQueue.main.async {
            self.spinenr.startAnimating()
            _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { Timer in
                self.spinenr.stopAnimating()
            })
        }
    }
    
    @objc func xMarkCloseVC() {
        if Constants.shared.isFirstLaunch == false {
            let vc = TabBar()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            Constants.shared.isFirstLaunch = true
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc func restoreButtonTapped() {
        
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
}

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}

extension SKProduct {
    
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}

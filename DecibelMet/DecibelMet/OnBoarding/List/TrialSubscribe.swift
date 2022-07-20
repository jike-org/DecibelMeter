//
//  SubscribeTwoView.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 16.05.22.
//

import Foundation
import UIKit
import StoreKit

class TrialSubscribe: UIViewController {
    
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
    
    lazy var subText = Label(style: .textSub, "")
    lazy var subText1 = Label(style: .textSub, "")
    lazy var subText2 = Label(style: .textSub, "")
    
    lazy var textView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    lazy var backgroundViewImage = UIImageView(image: UIImage(named: "04"))
    lazy var hStack = StackView(axis: .horizontal)
    lazy var privacy = Button(style: .subscriptionVC, lprivacy)
    lazy var restore = Button(style: .restoreButton, lrestore)
    lazy var terms = Button(style: .subscriptionVC, lterms)
    lazy var andLabel = Label(style: .time, land)
    lazy var xMark = Button(style: .close, "X")
    lazy var trialButton = Button(style: .trial, "Start with a 7 day trial, \(priceStringFor(product: product[3])) then per week")
    lazy var acces = Label(style: .acces, lAcces)
    lazy var spinenr = UIActivityIndicatorView(style: .large)
    
    let product = InAppManager.share.product
    
    
    lazy var weekSubscribe = Button(style: ._continue, "\(priceStringFor(product: product[3])) / \(lweek)")
    lazy var mounthSubscribe = Button(style: ._continue, "\(priceStringFor(product:product[1])) / \(lmounth)")
    lazy var yearSubscribe = Button(style: ._continue, "\(priceStringFor(product:product[5])) / \(lyear)")
    lazy var unlimited = Label(style: .timeTitle, "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        notificationCenter.addObserver(self, selector: #selector(trialButtonTapped1), name: NSNotification.Name(InAppPurchaseProduct.weekTrial.rawValue), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(trialButtonTapped1), name: NSNotification.Name(InAppPurchaseProduct.mounthTrial.rawValue), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(trialButtonTapped1), name: NSNotification.Name(InAppPurchaseProduct.yearTrial.rawValue), object: nil)
    }
    
    private func priceStringFor(product: SKProduct) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        
        print(numberFormatter.string(from: product.price)!)
        return numberFormatter.string(from: product.price)!
    }
}

extension TrialSubscribe {
    
    func setup() {
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
        
        terms.setTitleColor(.systemBlue, for: .normal)
        privacy.setTitleColor(.systemBlue, for: .normal)
        andLabel.tintColor = .white
        view.backgroundColor = .clear
        view.addSubview(backgroundViewImage)
        backgroundViewImage.addSubview(spinenr)
        backgroundViewImage.addSubview(textView)
        backgroundViewImage.addSubview(acces)
        textView.addSubview(subText)
        textView.addSubview(subText1)
        textView.addSubview(subText2)
        view.addSubview(trialButton)
        view.addSubview(hStack)
        view.addSubview(restore)
        view.addSubview(xMark)
        view.addSubview(weekSubscribe)
        view.addSubview(mounthSubscribe)
        view.addSubview(yearSubscribe)
        
        yearSubscribe.addTarget(self, action: #selector(yearSub), for: .touchUpInside)
        mounthSubscribe.addTarget(self, action: #selector(mounthSub), for: .touchUpInside)
        weekSubscribe.addTarget(self, action: #selector(weekSub), for: .touchUpInside)
        xMark.addTarget(self, action: #selector(xMarkTapped), for: .touchUpInside)
        restore.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        trialButton.addTarget(self, action: #selector(trialButtonTapped), for: .touchUpInside)
        privacy.addTarget(self, action: #selector(privacyTap), for: .touchUpInside)
        terms.addTarget(self, action: #selector(termsTap), for: .touchUpInside)
        hStack.spacing = 10
        spinenr.centerXAnchor.constraint(equalTo: backgroundViewImage.centerXAnchor).isActive = true
        spinenr.centerYAnchor.constraint(equalTo: backgroundViewImage.centerYAnchor).isActive = true
        spinenr.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewImage.frame = UIScreen.main.bounds
        hStack.translatesAutoresizingMaskIntoConstraints = false
        yearSubscribe.translatesAutoresizingMaskIntoConstraints = false
        mounthSubscribe.translatesAutoresizingMaskIntoConstraints = false
        weekSubscribe.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        trialButton.translatesAutoresizingMaskIntoConstraints = false
        hStack.addArrangedSubview(terms)
        hStack.addArrangedSubview(andLabel)
        hStack.addArrangedSubview(privacy)
        
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
            
            trialButton.bottomAnchor.constraint(equalTo: weekSubscribe.topAnchor, constant: -20),
            trialButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            acces.bottomAnchor.constraint(equalTo: textView.topAnchor, constant: -35),
            acces.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textView.bottomAnchor.constraint(equalTo: weekSubscribe.topAnchor, constant: -60),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 100),

            subText.topAnchor.constraint(equalTo: textView.topAnchor),
            subText.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            
            subText1.topAnchor.constraint(equalTo: subText.bottomAnchor, constant: 10),
            subText1.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            
            subText2.topAnchor.constraint(equalTo: subText1.bottomAnchor, constant: 10),
            subText2.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            
        ])
    }
}

extension TrialSubscribe {
    
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
        iapManager.purchase(productWith: "com.decibelmeter.1yetr")
        DispatchQueue.main.async {
            self.spinenr.startAnimating()
            _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { Timer in
                self.spinenr.stopAnimating()
            })
        }
    }
    
    @objc func mounthSub() {
        iapManager.purchase(productWith: "com.decibelmeter.1motr")
        DispatchQueue.main.async {
            self.spinenr.startAnimating()
            _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { Timer in
                self.spinenr.stopAnimating()
            })
        }
    }
    
    @objc func weekSub() {
        iapManager.purchase(productWith: "com.decibelmeter.1wetr")
        DispatchQueue.main.async {
            self.spinenr.startAnimating()
            _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { Timer in
                self.spinenr.stopAnimating()
            })
        }
    }
    
    @objc func trialButtonTapped1() {
        print("купил")
        Constants.shared.hasPurchased = true
        dismiss(animated: true)
        
    }
    
    @objc func xMarkTapped() {
        dismiss(animated: true)
    }
    
    @objc func restoreButtonTapped() {
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        print("restored")
    }
    
    @objc func trialButtonTapped() {
        iapManager.purchase(productWith: "com.decibelmeter.1wetr")
        DispatchQueue.main.async {
            self.spinenr.startAnimating()
            _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { Timer in
                self.spinenr.stopAnimating()
            })
        }
    }

}


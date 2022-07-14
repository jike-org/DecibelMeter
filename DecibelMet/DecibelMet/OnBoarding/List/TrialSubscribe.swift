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
    
    lazy var backgroundViewImage = UIImageView(image: UIImage(named: "04"))
    lazy var hStack = StackView(axis: .horizontal)
    lazy var privacy = Button(style: .link, lprivacy)
    lazy var restore = Button(style: .link, lrestore)
    lazy var terms = Button(style: .link, lterms)
    lazy var andLabel = Label(style: .time, land)
    lazy var xMark = Button(style: .close, "X")
    
    let product = InAppManager.share.product
    
    
    lazy var weekSubscribe = Button(style: ._continue, "\(priceStringFor(product: product[3])) / \(lweek)")
    lazy var mounthSubscribe = Button(style: ._continue, "\(priceStringFor(product:product[1])) / \(lmounth)")
    lazy var yearSubscribe = Button(style: ._continue, "\(priceStringFor(product:product[5])) / \(lyear)")
    lazy var unlimited = Label(style: .timeTitle, "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        for i in InAppManager.share.product {
            print (i.price)
        }
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
        view.backgroundColor = .clear
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
        hStack.spacing = 20
        backgroundViewImage.frame = UIScreen.main.bounds
        hStack.translatesAutoresizingMaskIntoConstraints = false
        yearSubscribe.translatesAutoresizingMaskIntoConstraints = false
        mounthSubscribe.translatesAutoresizingMaskIntoConstraints = false
        weekSubscribe.translatesAutoresizingMaskIntoConstraints = false
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
            weekSubscribe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension TrialSubscribe {
    
    @objc func yearSub() {
        iapManager.purchase(productWith: "com.decibelmeter.1ye")
    }
    
    @objc func mounthSub() {
        iapManager.purchase(productWith: "com.decibelmeter.1mo")
    }
    
    @objc func weekSub() {
        iapManager.purchase(productWith: "com.decibelmeter.1we")
    }
}

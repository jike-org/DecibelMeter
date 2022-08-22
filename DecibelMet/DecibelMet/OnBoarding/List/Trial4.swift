////
////  Trial4.swift
////  DecibelMet
////
////  Created by Stas Dashkevich on 10.08.22.
////
//// 4 screen
//
//import Foundation
//import UIKit
//import StoreKit
//import SwiftyStoreKit
//import FirebaseRemoteConfig
//
//class Trial4: UIViewController {
//
//    let iapManager = InAppManager.share
//    let remoteConfig = RemoteConfig.remoteConfig()
//    let product = InAppManager.share.product
//    var xMarkDelay = 0
//    var textDelay = 0
//    var sub = "com.decibelmeter.1wetr"
//
//
//    //MARK: - Localizable
//    var lTrial = NSLocalizedString("Start7Day", comment: "")
//    var lTrialThen = NSLocalizedString("Trial7", comment: "")
//    var lHeading = NSLocalizedString("UnlockAllAccess", comment: "")
//    var lRestore = NSLocalizedString("Restore", comment: "")
//    let lprivacy = NSLocalizedString("PrivacyPolice", comment: "")
//    let land = NSLocalizedString("and", comment: "")
//    let lterms = NSLocalizedString("TermsOfService", comment: "")
//    let lContinue = NSLocalizedString("Continue", comment: "")
//    let tTrial = NSLocalizedString("Start7Day", comment: "")
//    let lthen = NSLocalizedString("trialText", comment: "")
//    let lweekPer  = NSLocalizedString("perWeek", comment: "")
//    let small = NSLocalizedString("perWeekSmall", comment: "")
//    let lMounth = NSLocalizedString("perMounth", comment: "")
//    let lYear = NSLocalizedString("perYear", comment: "")
//    //MARK: - Create UI
//    lazy var restore = Button(style: .trial, lRestore)
//    lazy var xMark = Button(style: .close, "X")
//    lazy var headingLabel = Label(style: .onBoarding, lHeading.uppercased())
//    lazy var startTrial = Label(style: .trial, "")
//    lazy var continueButton = Button(style: ._continue, lContinue)
//    lazy var terms = Button(style: .trial, lterms)
//    lazy var privacy = Button(style: .trial, lprivacy)
//    lazy var andLabel = Label(style: .trial, land)
//    lazy var hStack = StackView(axis: .horizontal)
//    lazy var bcImage = UIImageView(image: UIImage(named: "04"))
//    lazy var spiner = UIActivityIndicatorView(style: .large)
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setup()
//        remoteConfigSetup()
//    }
//}
//
//extension Trial4 {
//
//    func setup() {
//
//
//        if Constants.shared.isFirstLaunch == false {
//            var t = ""
//            if let stringValue =
//                self.remoteConfig["otherSubscription"].stringValue {
//                print(t)
//                t = String(stringValue)
//            }
//
//            if t == "com.decibelmeter.1wetr" {
//                if  Locale.current.languageCode! == "tr"{
//                    startTrial.text = "\(lthen) \(small) \(priceStringFor(product: product[3])) ödeyin "
//                } else {
//                    startTrial.text =  "\(lthen) \n\(priceStringFor(product: product[3])) \(lweekPer)"
//                }
//            } else if  t == "com.decibelmeter.1we" {
//                startTrial.text = " \(NSLocalizedString("SubFor", comment: "")) \(priceStringFor(product: product[2])) \(lweekPer)"
//            } else if t == "com.decibelmeter.1mo" {
//                startTrial.text = " \(NSLocalizedString("SubFor", comment: "")) \(priceStringFor(product: product[2])) \(NSLocalizedString("perMounth", comment: ""))"
//            } else if t == "com.decibelmeter.1ye" {
//                startTrial.text = " \(NSLocalizedString("SubFor", comment: "")) \(priceStringFor(product: product[2])) \(NSLocalizedString("perYear", comment: ""))"
//            } else if t == "com.decibelmeter.1yetr" {
//                if  Locale.current.languageCode! == "tr"{
//                    startTrial.text = "\(lthen) \(small) \(priceStringFor(product: product[5])) ödeyin "
//                } else {
//                    startTrial.text =  "\(lthen) \n\(priceStringFor(product: product[5])) \(lweekPer)"
//                }
//            } else if t == "com.decibelmeter.1motr" {
//                if  Locale.current.languageCode! == "tr"{
//                    startTrial.text = "\(lthen) \(small) \(priceStringFor(product: product[1])) ödeyin "
//                } else {
//                    startTrial.text =  "\(lthen) \n\(priceStringFor(product: product[1])) \(lweekPer)"
//                }
//            }
//        } else {
//            var r = ""
//            if let stringValue =
//                self.remoteConfig["welcomeTourSubscription"].stringValue {
//                print(r)
//                r = String(stringValue)
//            }
//
//            if r == "com.decibelmeter.1wetr" {
//                if  Locale.current.languageCode! == "tr"{
//                    startTrial.text = "\(lthen) \(small) \(priceStringFor(product: product[3])) ödeyin "
//                } else {
//                    startTrial.text =  "\(lthen) \n\(priceStringFor(product: product[3])) \(lweekPer)"
//                }
//            } else if  r == "com.decibelmeter.1we" {
//                startTrial.text = " \(NSLocalizedString("SubFor", comment: "")) \(priceStringFor(product: product[2])) \(lweekPer)"
//            } else if r == "com.decibelmeter.1mo" {
//                startTrial.text = " \(NSLocalizedString("SubFor", comment: "")) \(priceStringFor(product: product[2])) \(NSLocalizedString("perMounth", comment: ""))"
//            } else if r == "com.decibelmeter.1ye" {
//                startTrial.text = " \(NSLocalizedString("SubFor", comment: "")) \(priceStringFor(product: product[2])) \(NSLocalizedString("perYear", comment: ""))"
//            } else if r == "com.decibelmeter.1yetr" {
//                if  Locale.current.languageCode! == "tr"{
//                    startTrial.text = "\(lthen) \(small) \(priceStringFor(product: product[5])) ödeyin "
//                } else {
//                    startTrial.text =  "\(lthen) \n\(priceStringFor(product: product[5])) \(lweekPer)"
//                }
//            } else if r == "com.decibelmeter.1motr" {
//                if  Locale.current.languageCode! == "tr"{
//                    startTrial.text = "\(lthen) \(small) \(priceStringFor(product: product[1])) ödeyin "
//                } else {
//                    startTrial.text =  "\(lthen) \n\(priceStringFor(product: product[1])) \(lweekPer)"
//                }
//            }
//        }
//
//
//
//        bcImage.frame = UIScreen.main.bounds
//        view.addSubview(bcImage)
//        view.addSubview(restore)
//        view.addSubview(xMark)
//        view.addSubview(headingLabel)
//        view.addSubview(startTrial)
//        view.addSubview(continueButton)
//        view.addSubview(hStack)
//        view.addSubview(spiner)
//
//        spiner.translatesAutoresizingMaskIntoConstraints = false
//        hStack.translatesAutoresizingMaskIntoConstraints = false
//
//        hStack.addArrangedSubview(terms)
//        hStack.addArrangedSubview(andLabel)
//        hStack.addArrangedSubview(privacy)
//
//        startTrial.isHidden = true
//        xMark.isHidden = true
//        hStack.spacing = 7
//        privacy.setTitleColor(.systemBlue, for: .normal)
//        terms.setTitleColor(.systemBlue, for: .normal)
//
//        xMark.addTarget(self, action: #selector(xMarkTapped), for: .touchUpInside)
//        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
//        terms.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
//        privacy.addTarget(self, action: #selector(privacyTapped), for: .touchUpInside)
//        restore.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
//
//        NSLayoutConstraint.activate([
//
//            restore.topAnchor.constraint(equalTo: bcImage.safeAreaLayoutGuide.topAnchor),
//            restore.leadingAnchor.constraint(equalTo: bcImage.leadingAnchor, constant: 20),
//            restore.widthAnchor.constraint(equalToConstant: 120),
//            restore.heightAnchor.constraint(equalToConstant: 20),
//
//            xMark.topAnchor.constraint(equalTo: bcImage.safeAreaLayoutGuide.topAnchor),
//            xMark.trailingAnchor.constraint(equalTo: bcImage.trailingAnchor, constant: -20),
//            xMark.widthAnchor.constraint(equalToConstant: 60),
//            xMark.heightAnchor.constraint(equalToConstant: 30),
//
//            hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            hStack.heightAnchor.constraint(equalToConstant: 30),
//
//            continueButton.bottomAnchor.constraint(equalTo: hStack.topAnchor, constant: -30),
//            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
//            startTrial.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -30),
//            startTrial.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
//            startTrial.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
//
//            headingLabel.bottomAnchor.constraint(equalTo: startTrial.topAnchor, constant: -30),
//            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
//            spiner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            spiner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//
//    func remoteConfigSetup() {
//        let setting = RemoteConfigSettings()
//        setting.minimumFetchInterval = 0
//        remoteConfig.configSettings = setting
//
//        remoteConfig.fetchAndActivate { (status, error) in
//
//            if error !=  nil {
//                print(error?.localizedDescription)
//            } else {
//                if status != .error {
//                    if let stringValue =
//                        self.remoteConfig["closeButtonDelay"].stringValue {
//                        print (stringValue)
//                        self.xMarkDelay = Int(stringValue)!
//                    }
//                }
//            }
//
//            if error !=  nil {
//                print(error?.localizedDescription)
//            } else {
//                if status != .error {
//                    if let stringValue =
//                        self.remoteConfig["textSubscriptionDelay"].stringValue {
//                        print (stringValue)
//                        self.textDelay = Int(stringValue)!
//                    }
//                }
//            }
//
//            if error !=  nil {
//                print(error?.localizedDescription)
//            } else {
//                if status != .error {
//                    if let stringValue =
//                        self.remoteConfig["welcomeTourSubscription"].stringValue {
//                        print (stringValue)
//                        self.sub = stringValue
//                    }
//                }
//            }
//        }
//
//        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(xMarkDelay), repeats: false) { [self] Timer in
//            xMark.isHidden = false
//        }
//
//        let _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(textDelay), repeats: false) { [self] Timer in
//            startTrial.isHidden = false
//        }
//    }
//}
//
//extension Trial4 {
//
//    @objc func termsTapped() {
//        let url = URL(string: "https://www.mindateq.io/terms-of-use")
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//    }
//
//    @objc func xMarkTapped() {
//       if Constants.shared.isFirstLaunch == false {
//            let vc = TabBar()
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
//           Constants.shared.isFirstLaunch = true
//        } else {
//            dismiss(animated: true)
//        }
//    }
//
//    @objc func privacyTapped() {
//        let url = URL(string: "https://www.mindateq.io/privacy-policy")
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//    }
//
//    @objc func continueTapped() {
//
//
//        if sub == "com.decibelmeter.1wetr" {
//            iapManager.purchase(productWith: "com.decibelmeter.1wetr")
//            spiner.startAnimating()
//            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
//                spiner.stopAnimating()
//            }
//        } else if  sub == "com.decibelmeter.1we" {
//            iapManager.purchase(productWith: "com.decibelmeter.1we")
//            spiner.startAnimating()
//            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
//                spiner.stopAnimating()
//            }
//        } else if sub == "com.decibelmeter.1mo" {
//            iapManager.purchase(productWith: "com.decibelmeter.1mo")
//            spiner.startAnimating()
//            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
//                spiner.stopAnimating()
//            }
//        } else if sub == "com.decibelmeter.1ye" {
//            iapManager.purchase(productWith: "com.decibelmeter.1ye")
//            spiner.startAnimating()
//            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
//                spiner.stopAnimating()
//            }
//        } else if sub == "com.decibelmeter.1yetr" {
//            iapManager.purchase(productWith: "com.decibelmeter.1yetr")
//            spiner.startAnimating()
//            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
//                spiner.stopAnimating()
//            }
//        } else if sub == "com.decibelmeter.1motr" {
//            iapManager.purchase(productWith: "com.decibelmeter.1motr")
//            spiner.startAnimating()
//            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [self] Timer in
//                spiner.stopAnimating()
//            }
//        }
//
//    }
//    @objc func restoreTapped() {
//
//        let alertController = UIAlertController(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("subNO", comment: ""), preferredStyle: .alert)
//
//        let cancelButton = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
//
//        alertController.addAction(cancelButton)
//
//        let alertController2 = UIAlertController(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("subYES", comment: ""), preferredStyle: .alert)
//
//        let cancelButton2 = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
//
//        alertController2.addAction(cancelButton2)
//        SKPaymentQueue.default().restoreCompletedTransactions()
//
//        if Constants.shared.hasPurchased == true {
//            self.present(alertController2, animated: true, completion: nil)
//        } else {
//            self.present(alertController, animated: true, completion: nil)
//        }
//
//
//
//    }
//
//    private func priceStringFor(product: SKProduct) -> String {
//
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .currency
//        numberFormatter.locale = product.priceLocale
//
//        print(numberFormatter.string(from: product.price)!)
//        return numberFormatter.string(from: product.price)!
//    }
//
//
//}

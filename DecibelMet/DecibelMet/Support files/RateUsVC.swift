//
//  RateUsVC.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 16.07.22.
//

import Foundation
import UIKit
import StoreKit
import MessageUI

class RateUsVC: UIViewController {
    
    let lYes = NSLocalizedString("Yes", comment: "")
    let lNo = NSLocalizedString("No", comment: "")
    let lLike = NSLocalizedString("LikeApp", comment: "")
    lazy var yesButton = Button(style: .rateus, lYes)
    lazy var noButton = Button(style: .rateus, lNo)
    lazy var likeLabel = Label(style: .likeLabel, lLike)
    
    var counterDismiss = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        counterDismiss += 1

        if counterDismiss % 2 == 0 {
            dismiss(animated: true)
        }
    }
    
    lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.widthAnchor.constraint(equalToConstant: 345).isActive = true
        view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return view
    }()
    
    lazy var upperLine: UIView = {
        let view = UIView()
        view.backgroundColor = .blue.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .blue.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

extension RateUsVC {
    
    func setup() {
        
        mainView.addSubview(likeLabel)
        mainView.addSubview(upperLine)
        mainView.addSubview(yesButton)
        mainView.addSubview(noButton)
        mainView.addSubview(verticalLine)
        view.backgroundColor = UIColor(named: "rateUs")
        likeLabel.textColor = .black
        view.backgroundColor?.withAlphaComponent(0.7)
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        yesButton.addTarget(self, action: #selector(YesTapped), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(NoTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            yesButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            yesButton.heightAnchor.constraint(equalToConstant: 70),
            yesButton.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.5),
            yesButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            
            noButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            noButton.heightAnchor.constraint(equalToConstant: 70),
            noButton.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.5),
            noButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            
            upperLine.bottomAnchor.constraint(equalTo: noButton.topAnchor),
            upperLine.heightAnchor.constraint(equalToConstant: 1),
            upperLine.widthAnchor.constraint(equalTo: mainView.widthAnchor),
            
            verticalLine.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            verticalLine.heightAnchor.constraint(equalToConstant: 70),
            verticalLine.widthAnchor.constraint(equalToConstant: 1),
            verticalLine.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            
            likeLabel.bottomAnchor.constraint(equalTo: yesButton.topAnchor, constant: -20),
            likeLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            likeLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
        ])
    }
}

extension RateUsVC {
    
    @objc func YesTapped() {
        
        let productURL = URL(string: "https://apps.apple.com/us/app/decibel-meter-sound-level-db/id1624503658")
        
        var components = URLComponents(url: productURL!, resolvingAgainstBaseURL: false)

        components?.queryItems = [
          URLQueryItem(name: "action", value: "write-review")
        ]

        guard let writeReviewURL = components?.url else {
          return
        }

        UIApplication.shared.open(writeReviewURL)
        
        dismiss(animated: true)
    }
    
    @objc func NoTapped() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            let systemVersion = UIDevice.current.systemVersion
            let devicename = UIDevice.modelName
            let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            mail.setToRecipients(["support@mindateq.io"])
            mail.setSubject("Decibel Meter — User Question ")
            mail.setMessageBody("<p>\(systemVersion) \(devicename)<p>build Number -  \(appVersion!) (\(buildNumber))</p> </p>", isHTML: true)
            mail.modalPresentationStyle = .fullScreen
            present(mail, animated: true)
        } else {
            
        }
//        dismiss(animated: true)
    }
}

extension RateUsVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

//
//  SettingViewController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 5.05.22.
//

import Foundation
import UIKit
import StoreKit
import MessageUI

class SettingsView: UIViewController {
    
    lazy var titleLabel = Label(style: .titleLabel, "Settings")
    let cellSpacingHeight: CGFloat = 40
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        
        t.translatesAutoresizingMaskIntoConstraints = false
        
        t.delegate   = self
        t.dataSource = self
        
        t.backgroundColor = .clear
        t.separatorColor  = UIColor(named: "SeparatorColor")
        
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension SettingsView {
    
    private func setupView() {
        view.backgroundColor = .black
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}


// MARK: Table delegate & datasource
extension SettingsView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return cellSpacingHeight
      }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SettingsCell(
            reuseIdentifier: "cell",
            icon: ImageView(image: .lock),
            label: Label(style: .tableLabel, "User agreement"),
            isUsingSwitch: false
        )
        
        switch indexPath.row {
        case 0:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .lock),
                label: Label(style: .tableLabel, "Unlock all features"),
                isUsingSwitch: false
            )
        case 1:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .faq),
                label: Label(style: .tableLabel, "FAQ"),
                isUsingSwitch: false
            )
        case 2:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .rate),
                label: Label(style: .tableLabel, "Rate us"),
                isUsingSwitch: false
            )
        case 3:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .support),
                label: Label(style: .tableLabel, "Support"),
                isUsingSwitch: false
            )
        case 4:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .privacy),
                label: Label(style: .tableLabel, "Privacy police"),
                isUsingSwitch: false
            )
        case 5:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .terms),
                label: Label(style: .tableLabel, "Terms of use"),
                isUsingSwitch: false
            )
        case 6:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .share),
                label: Label(style: .tableLabel, "Share with friends"),
                isUsingSwitch: false
            )
        case 7:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .share),
                label: Label(style: .tableLabel, "Dark theme"),
                isUsingSwitch: true
            )
        default:
            break
        }
        
        return cell
    }
    
    private func shereAs() {
        let textToShare = "DecibelMeter"
        
        if let myWebsite = NSURL(string: "https://www.google.com") {
            let objectsToShare: [Any] = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = OnboardingView()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        case 1:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 2:
            SKStoreReviewController.requestReview()
        case 3:
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["support@mindateq.io"])
                    mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

                    present(mail, animated: true)
                } else {
                    // show failure alert
                }
            

        case 4:
            if let url = URL(string: "https://www.mindateq.io/privacy-policy") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 5:
            if let url = URL(string: "https://www.mindateq.io/terms-of-use") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case 6:
            shereAs()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension SettingsView: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}



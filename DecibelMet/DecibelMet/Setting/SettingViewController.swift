//
//  SettingViewController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 5.05.22.
//
// льготный

import Foundation
import UIKit
import StoreKit
import MessageUI
import FirebaseRemoteConfig

class SettingsView: UIViewController {
    //MARK: Localizable
    let remoteConfig = RemoteConfig.remoteConfig()
    let notificationCenter = NotificationCenter.default
    let settings = NSLocalizedString("Settings", comment: "")
    var darkTheme = NSLocalizedString("Darktheme", comment: "")
    var dos = NSLocalizedString("Dosimeter", comment: "")
    var shareFriends = NSLocalizedString("Sharewithfriends", comment: "")
    var termsOfUse = NSLocalizedString("TermsOfUse", comment: "")
    var privacyPolice = NSLocalizedString("Privacypolicy", comment: "")
    var support = NSLocalizedString("Support", comment: "")
    var rateUs = NSLocalizedString("Rateus", comment: "")
    var faq = NSLocalizedString("FAQ", comment: "")
    var unlockAll = NSLocalizedString("Unlockallfeatures", comment: "")
    var lAcces = NSLocalizedString("", comment: "")
    private var changeSub: String = "1"
    var rese = NSLocalizedString("reset", comment: "")
    var rateUsInt = 0
    lazy var titleLabel = Label(style: .titleLabel, settings)
    let cellSpacingHeight: CGFloat = 40
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        
        t.translatesAutoresizingMaskIntoConstraints = false
        
        t.delegate   = self
        t.dataSource = self
        t.separatorColor  = UIColor(named: "SeparatorColor")
        
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
//        notificationCenter.addObserver(self, selector: #selector(trialButtonTapped1), name: NSNotification.Name(InAppPurchaseProduct.weekTrial.rawValue), object: nil)
//        
//        notificationCenter.addObserver(self, selector: #selector(trialButtonTapped1), name: NSNotification.Name(InAppPurchaseProduct.mounthTrial.rawValue), object: nil)
//        
//        notificationCenter.addObserver(self, selector: #selector(trialButtonTapped1), name: NSNotification.Name(InAppPurchaseProduct.yearTrial.rawValue), object: nil)
        
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
                        self.remoteConfig["otherScreenNumber"].stringValue {
                        self.changeSub = stringValue
                    }
                }
                
                if status != .error {
                    if let stringValue2 =
                        self.remoteConfig["rateUs"].stringValue {
                        self.rateUsInt = Int(stringValue2)!
                    }
                }

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
    }
}


extension SettingsView {
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        tableView.delaysContentTouches = false
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
    
    @objc func trialButtonTapped1() {
        tableView.reloadData()
        dismiss(animated: true)
    }
    
}


// MARK: Table delegate & datasource
extension SettingsView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.value(forKey: "FullAccess") as! Int == 1 {
            return 8
        } else {
            return 9
        }
   
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return cellSpacingHeight
      }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = SettingsCell(
            reuseIdentifier: "cell",
            icon: ImageView(image: .nul),
            label: Label(style: .settingLabel, ""),
            isUsingSwitch: false,
            chevron: ImageView(image: .nul)
        )
        
        cell.selectionStyle = .default
        if UserDefaults.standard.value(forKey: "FullAccess") as! Int == 0 {
        
        switch indexPath.row {
        case 0:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .lock),
                label: Label(style: .settingLabel, unlockAll),
                isUsingSwitch: false,
                chevron: ImageView(image: .chevron)
            )
        case 1:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .faq),
                label: Label(style: .settingLabel, faq),
                isUsingSwitch: false,
                chevron: ImageView(image: .chevron)
            )
        case 2:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .rate),
                label: Label(style: .settingLabel, rateUs),
                isUsingSwitch: false,
                chevron: ImageView(image: .chevron)
            )
        case 3:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .support),
                label: Label(style: .settingLabel, support),
                isUsingSwitch: false,
                chevron: ImageView(image: .chevron)
            )
        case 4:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .privacy),
                label: Label(style: .settingLabel, privacyPolice),
                isUsingSwitch: false,
                chevron: ImageView(image: .chevron)
            )
        case 5:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .terms),
                label: Label(style: .settingLabel, termsOfUse),
                isUsingSwitch: false,
                chevron: ImageView(image: .chevron)
            )
        case 6:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .share),
                label: Label(style: .settingLabel, shareFriends),
                isUsingSwitch: false,
                chevron: ImageView(image: .chevron)
            )
        case 7:
            cell = SettingsCell(
                reuseIdentifier: "cell",
                icon: ImageView(image: .darkMode),
                label: Label(style: .settingLabel, darkTheme),
                isUsingSwitch: true,
                chevron: ImageView(image: .nul)
                )
                case 8:
                    cell = SettingsCell(
                        reuseIdentifier: "cell",
                        icon: ImageView(image: .refresh),
                        label: Label(style: .settingLabel,"\(rese) \(dos)"),
                        isUsingSwitch: false,
                        chevron: ImageView(image: .chevron)
                    )
            
        default:
            break
        }
        }
            if UserDefaults.standard.value(forKey: "FullAccess") as! Int == 1 {
            
            switch indexPath.row {
//            case 0:
//                cell = SettingsCell(
//                    reuseIdentifier: "cell",
//                    icon: ImageView(image: .lock),
//                    label: Label(style: .tableLabel, unlockAll),
//                    isUsingSwitch: false,
//                    chevron: ImageView(image: .chevron)
//                )
            case 0:
                cell = SettingsCell(
                    reuseIdentifier: "cell",
                    icon: ImageView(image: .faq),
                    label: Label(style: .settingLabel, faq),
                    isUsingSwitch: false,
                    chevron: ImageView(image: .chevron)
                )
            case 1:
                cell = SettingsCell(
                    reuseIdentifier: "cell",
                    icon: ImageView(image: .rate),
                    label: Label(style: .settingLabel, rateUs),
                    isUsingSwitch: false,
                    chevron: ImageView(image: .chevron)
                )
            case 2:
                cell = SettingsCell(
                    reuseIdentifier: "cell",
                    icon: ImageView(image: .support),
                    label: Label(style: .settingLabel, support),
                    isUsingSwitch: false,
                    chevron: ImageView(image: .chevron)
                )
            case 3:
                cell = SettingsCell(
                    reuseIdentifier: "cell",
                    icon: ImageView(image: .privacy),
                    label: Label(style: .settingLabel, privacyPolice),
                    isUsingSwitch: false,
                    chevron: ImageView(image: .chevron)
                )
            case 4:
                cell = SettingsCell(
                    reuseIdentifier: "cell",
                    icon: ImageView(image: .terms),
                    label: Label(style: .settingLabel, termsOfUse),
                    isUsingSwitch: false,
                    chevron: ImageView(image: .chevron)
                )
            case 5:
                cell = SettingsCell(
                    reuseIdentifier: "cell",
                    icon: ImageView(image: .share),
                    label: Label(style: .settingLabel, shareFriends),
                    isUsingSwitch: false,
                    chevron: ImageView(image: .chevron)
                )
            case 6:
                cell = SettingsCell(
                    reuseIdentifier: "cell",
                    icon: ImageView(image: .darkMode),
                    label: Label(style: .settingLabel, darkTheme),
                    isUsingSwitch: true,
                    chevron: ImageView(image: .nul)
                )
            case 7:
                cell = SettingsCell(
                    reuseIdentifier: "cell",
                    icon: ImageView(image: .refresh),
                    label: Label(style: .settingLabel, "\(rese) \(dos)"),
                    isUsingSwitch: false,
                    chevron: ImageView(image: .nul)
                )
            default:
                break
        }
    }
        return cell
    }
    
    
    private func shereAs() {
        let textToShare = NSLocalizedString("appWil", comment: "")
        
        if let myWebsite = URL(string: "https://apps.apple.com/us/app/decibel-meter-sound-level-db/id1624503658") {
            let activityVC = UIActivityViewController(activityItems: [textToShare , myWebsite ], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            
        }
    }
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()

        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            } else {
                let vc = RateUsVC()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            }
        }
    }
    
    private func shareAs() {
        var textToShare = NSLocalizedString("appWil", comment: "")
        textToShare += "https://apps.apple.com/us/app/decibel-meter-sound-level-db/id1624503658"
        
            let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            
    }
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserDefaults.standard.value(forKey: "FullAccess") as! Int == 0 {
        switch indexPath.row {
        case 0:
            if changeSub == "2"{
                let vcTwo = SubscribeTwoView()
                vcTwo.modalPresentationStyle = .fullScreen
                present(vcTwo, animated: true, completion: nil)
            } else if changeSub == "1" {
                    let vcTrial = TrialSubscribe()
                vcTrial.modalPresentationStyle = .fullScreen
                present(vcTrial, animated: true, completion: nil)
            } else if changeSub == "3" {
            let vcTrial = TrialViewController()
            vcTrial.modalPresentationStyle = .fullScreen
            present(vcTrial, animated: true, completion: nil)
            } else {
                let vcTrial = TrialSubscribe()
            vcTrial.modalPresentationStyle = .fullScreen
            present(vcTrial, animated: true, completion: nil)
            }
        case 1:
            let vc = FAQSetting()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        case 2:
            if rateUsInt == 0 {
                DispatchQueue.main.async { [self] in
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
            } else {
                DispatchQueue.main.async { [self] in
                        let vc = RateUsVC()
                        vc.modalPresentationStyle = .fullScreen
                        present(vc, animated: true, completion: nil)
                }
            }
         
        case 3:
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
                    
                    present(mail, animated: true)
                } else {
                    
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
            shareAs()
            shereAs()
        case 8:
            let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
//            UIApplication.shared.keyWindow?.rootViewController = TabBar()
            keyWindow?.rootViewController = TabBar()
        default:
            break
        }
        } else {
            switch indexPath.row {
                
                
            
            case 0:
                let vc = FAQSetting()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            case 1:
                if rateUsInt == 0 {
                    DispatchQueue.main.async { [self] in
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
                } else {
                    DispatchQueue.main.async { [self] in
                            let vc = RateUsVC()
                            vc.modalPresentationStyle = .fullScreen
                            present(vc, animated: true, completion: nil)
                    }
                }
             
            case 2:
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
                        
                        present(mail, animated: true)
                    } else {
                        
                    }
            case 3:
                if let url = URL(string: "https://www.mindateq.io/privacy-policy") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            case 4:
                if let url = URL(string: "https://www.mindateq.io/terms-of-use") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            case 5:
                shareAs()
                shereAs()
            case 7:
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .compactMap({$0 as? UIWindowScene})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
    //            UIApplication.shared.keyWindow?.rootViewController = TabBar()
                keyWindow?.rootViewController = TabBar()
                
//            case 1:
//                let vc = FAQSetting()
//                vc.modalPresentationStyle = .fullScreen
//                present(vc, animated: true, completion: nil)
//            case 2:
//                if rateUsInt == 0 {
////                    DispatchQueue.main.async { [self] in
////                        if Int(UserDefaults.standard.string(forKey: "enterCounter")!)! == 2 {
////                            rateApp()
////                        }
////                    }
//                    rateApp()
//                } else {
////                    DispatchQueue.main.async { [self] in
////                        if Int(UserDefaults.standard.string(forKey: "enterCounter")!)! == 2 {
////                            let vc = RateUsVC()
////                            vc.modalPresentationStyle = .fullScreen
////                            present(vc, animated: true, completion: nil)
////                        }
////                    }
////                    let t = Int(UserDefaults.standard.string(forKey: "enterCounter")!)!
//                    let vc = RateUsVC()
//                    vc.modalPresentationStyle = .fullScreen
//                    present(vc, animated: true, completion: nil)
//                }
//            case 3:
//                    if MFMailComposeViewController.canSendMail() {
//                        let mail = MFMailComposeViewController()
//                        mail.mailComposeDelegate = self
//                        mail.setToRecipients(["support@mindateq.io"])
//                        mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
//
//                        present(mail, animated: true)
//                    } else {
//                        // show failure alert
//                    }
//            case 4:
//                if let url = URL(string: "https://www.mindateq.io/privacy-policy") {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            case 5:
//                if let url = URL(string: "https://www.mindateq.io/terms-of-use") {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            case 5:
//                shereAs()
            default:
                break
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SettingsView: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}



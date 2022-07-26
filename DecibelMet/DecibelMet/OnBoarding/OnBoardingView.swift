//
//  OnBoardingView.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 15.05.22.
//

import Foundation
import UIKit
import StoreKit
import FirebaseRemoteConfig

class OnboardingView: UIViewController {
    
    private var changeSub = "1"
    let iapManager = InAppManager.share
    let lprivacy = NSLocalizedString("PrivacyPolice", comment: "")
    let land = NSLocalizedString("and", comment: "")
    let lrestore = NSLocalizedString("Restore", comment: "")
    let lterms = NSLocalizedString("TermsOfService", comment: "")
    let notificationCenter = NotificationCenter.default
    private let app = UIApplication.shared.delegate
    private var currentIndex: IndexPath = .init(index: 0)
    private let remoteConfig = RemoteConfig.remoteConfig()
    private var xMarkDelay: Int = 0
    private var textDelay: Int = 0
    
    // MARK: UI elements
    lazy var collectionView = CollectionView(
        delegate: self,
        dataSource: self
    )
    
    // Stack view
    lazy var stackView = StackView(axis: .horizontal)
    
    // Buttons
    lazy var spinenr = UIActivityIndicatorView(style: .large)
    lazy var closeButton = Button(style: .close, nil)
    let lContinue = NSLocalizedString("Continue", comment: "")
    lazy var continueButton = Button(style: ._continue, lContinue)
    lazy var termsOfUseButton = Button(style: .link, lterms)
    lazy var privacyPolicyButton = Button(style: .link, lprivacy)
    lazy var andUnderLabel = Button(style: .link, land)
    lazy var restoreButton = Button(style: .trial, lrestore)
    
    lazy var separatorOne = UILabel()
    lazy var separatorTwo = UILabel()
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchValues()
        setupView()
        
        notificationCenter.addObserver(self, selector: #selector(trialButtonTapped1), name: NSNotification.Name(InAppPurchaseProduct.week.rawValue), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(trialButtonTapped1), name: NSNotification.Name(InAppPurchaseProduct.mounth.rawValue), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(trialButtonTapped1), name: NSNotification.Name(InAppPurchaseProduct.year.rawValue), object: nil)
    }
    
    @objc func trialButtonTapped1() {
        print("купил")
        Constants.shared.hasPurchased = true
        
        let vc = TabBar()
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        remoteConfig.fetchAndActivate { (status, error) in
            
            if error !=  nil {
                print(error?.localizedDescription)
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["closeButtonDelay"].stringValue {
                        self.xMarkDelay = Int(stringValue)!
                    }
                }
            }
        }
        
        remoteConfig.fetchAndActivate { (status, error) in
            
            if error !=  nil {
                print(error?.localizedDescription)
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["welcomeTourScreenNumber"].stringValue {
                        self.changeSub = stringValue
                        print(self.changeSub)
                    }
                }
            }
        }
    }
}

// MARK: Setup view
extension OnboardingView {
    
    func setupView() {
        view.backgroundColor = #colorLiteral(red: 0.003166671842, green: 0.003117467742, blue: 0.1896977425, alpha: 1)
        termsOfUseButton.setTitleColor(UIColor.systemBlue, for: .normal)
        andUnderLabel.setTitleColor(UIColor.white, for: .normal)
        privacyPolicyButton.setTitleColor(UIColor.systemBlue, for: .normal)
        
        separatorOne.textAlignment = .center
        separatorOne.textColor = .black
        separatorOne.font = UIFont(name: "OpenSans-Regular", size: 13)
        
        separatorTwo.textAlignment = .center
        separatorTwo.textColor = .black
        separatorTwo.font = UIFont(name: "OpenSans-Regular", size: 13)
        
        closeButton.isHidden = true
        closeButton.layer.zPosition = 10
        closeButton.addTarget(self, action: #selector(closeOnboarding), for: .touchUpInside)
        
        restoreButton.isHidden = true
        restoreButton.layer.zPosition = 1
        restoreButton.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        
        // MARK: Go to next page
        view.addSubview(spinenr)
        spinenr.layer.zPosition = 1
        spinenr.translatesAutoresizingMaskIntoConstraints = false
        spinenr.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinenr.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        continueButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        termsOfUseButton.addTarget(self, action: #selector(getTermsOfUse), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(getPrivacyPolicy), for: .touchUpInside)
      
//        trialButton.addTarget(self, action: #selector(trialButtonTapped), for: .touchUpInside)
        
        // MARK: Register slides
        collectionView.register(FirstListViewController.self, forCellWithReuseIdentifier: FirstListViewController.identifier)
        collectionView.register(SecondListViewController.self, forCellWithReuseIdentifier: SecondListViewController.identifier)
        collectionView.register(ThirdListViewController.self, forCellWithReuseIdentifier: ThirdListViewController.identifier)
//        collectionView.register(SubscribeViewController.self, forCellWithReuseIdentifier: SubscribeViewController.identifier)
        
        view.addSubview(restoreButton)
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(continueButton)
        view.addSubview(stackView)
//        view.addSubview(trialButton)
        stackView.addArrangedSubview(termsOfUseButton)
        stackView.addArrangedSubview(separatorOne)
        stackView.addArrangedSubview(andUnderLabel)
        stackView.addArrangedSubview(separatorTwo)
        stackView.addArrangedSubview(privacyPolicyButton)
        
        let constraints = [
            
            // MARK: Close button
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            restoreButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            restoreButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            restoreButton.heightAnchor.constraint(equalToConstant: 40),
            restoreButton.widthAnchor.constraint(equalToConstant: 90),
            
            // MARK: Collection view
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // MARK: Continue button
            continueButton.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -15),
            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // MARK: Stack view
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
}

// MARK: Button actions
extension OnboardingView {
    
    @objc func closeOnboarding() {
        OnboardingManager.shared.isFirstLaunch = true
        
        let vc = TabBar()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func fetchValues() {
    
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
    }
    
    @objc func trialButtonTapped() {
        print("fknas")
    }
    
    @objc func nextPage() {
        if currentIndex.row < 2 {
            collectionView.scrollToItem(at: IndexPath(arrayLiteral: 0, currentIndex.row + 1), at: .centeredHorizontally, animated: true)
        } else if currentIndex.row == 3 {

//            if changeSub == "1"{
//                let vcTwo = SubscribeTwoView()
//                vcTwo.modalPresentationStyle = .fullScreen
//                present(vcTwo, animated: true, completion: nil)
//            } else if changeSub == "2" {
//                    let vcTrial = TrialSubscribe()
//                vcTrial.modalPresentationStyle = .fullScreen
//                present(vcTrial, animated: true, completion: nil)
//            } else if changeSub == "3" {
//            let vcTrial = TrialViewController()
//            vcTrial.modalPresentationStyle = .fullScreen
//            present(vcTrial, animated: true, completion: nil)
//            }
        } else {
            let _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [self] Timer in
                if changeSub == "1"{
                    Constants.shared.isFirstLaunch = true
                    let vcTwo = SubscribeTwoView()
                    vcTwo.modalPresentationStyle = .fullScreen
                    present(vcTwo, animated: true, completion: nil)
                } else if changeSub == "2" {
                        let vcTrial = TrialSubscribe()
                    Constants.shared.isFirstLaunch = true
                    vcTrial.modalPresentationStyle = .fullScreen
                    present(vcTrial, animated: true, completion: nil)
                } else if changeSub == "3" {
                    Constants.shared.isFirstLaunch = true
                let vcTrial = TrialViewController()
                vcTrial.modalPresentationStyle = .fullScreen
                present(vcTrial, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func getTermsOfUse() {
        print("Terms of use")
        
        let url = URL(string: "https://www.mindateq.io/terms-of-use")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func getPrivacyPolicy() {
        print("Privacy policy")
        
        let url = URL(string: "https://www.mindateq.io/privacy-policy")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @objc func restoreButtonTapped() {
        SKPaymentQueue.default().restoreCompletedTransactions()
        
        print("restored")
    }
    
}


// MARK: Collection view data source
extension OnboardingView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var slide: String

        switch indexPath.row {
        case 0:
            slide = FirstListViewController.identifier
            termsOfUseButton.isHidden = true
            privacyPolicyButton.isHidden = true
            andUnderLabel.isHidden = true
            restoreButton.isHidden = true
        case 1:
            slide = SecondListViewController.identifier
            termsOfUseButton.isHidden = true
            privacyPolicyButton.isHidden = true
            andUnderLabel.isHidden = true
            restoreButton.isHidden = true
        case 2:
            slide = ThirdListViewController.identifier
            termsOfUseButton.isHidden = true
            privacyPolicyButton.isHidden = true
            andUnderLabel.isHidden = true
            restoreButton.isHidden = true

        default:
            slide = FirstListViewController.identifier
            termsOfUseButton.isHidden = true
            privacyPolicyButton.isHidden = true
            andUnderLabel.isHidden = true
            restoreButton.isHidden = true
        }
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: slide, for: indexPath)
        return item
    }
    
}


// MARK: Collection view delegate
extension OnboardingView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        currentIndex = indexPath
        
        UIView.transition(with: closeButton, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: { _ in })
    }
    
}

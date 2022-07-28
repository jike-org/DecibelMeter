//
//  FAQSetting.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 15.07.22.
//

import Foundation
import UIKit

final class FAQSetting: UIViewController {
    
    
    // MARK: FAQSetting constant
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let lFAQ = NSLocalizedString("FAQ", comment: "")
    
    let howToUseText =  """
  The sound level meter can measure ambient noise in real time, as well as record and play recordings. For the sound level meter to work and determine the level of detected noise, open access to the microphone of your device. The sound data read by the microphone is expressed in decibels (dB).
  On the main screen, there is the current measurement and multiple controls. The big blue record button (start of measurement) is in the middle.
  MAX — a maximum value in the current measurement.
  AVG — an average value in the current measurement.
  MIN — an minimum average value in the current measurement.
  """
    let measureText = """
    If instead of measurements you see a zero on the main screen, then you have banned the sound level meter to access your microphone. Go to Settings > Privacy policy > Microphone and allow the program access to the microphone.
  """
    let locationText = """
  If the program does not save information on geographical position during recording, it means you have banned to access to geographical location data. Go to Settings > Privacy policy > Location Services and allow the program to access the data.
  """
    
    lazy var chevronImage = Button(style: .chevronRight, "")
    lazy var headLabel = Label(style: .headingFAQ, lFAQ)
    
    lazy var howToUse = Label(style: .headingFAQ, "How to use the application?")
    lazy var stringHowToUse = Label(style: .textFAQ, howToUseText)
    
    lazy var appMeasure = Label(style: .headingFAQ, "Why doesn't the app measure the noise level and the main screen shows zero?")
    lazy var stringMeasure = Label(style: .textFAQ, measureText)
    
    lazy var geoLocation = Label(style: .headingFAQ, "Why doesn't the app store geo-location information while recording?")
    lazy var stringLocation = Label(style: .textFAQ, locationText)
    
    lazy var onelineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var secondlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var thirdlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setUpHeaderView()
        setupScrollView()
        setupViews()
    }
    // MARK: FAQSetting function view
    private func setUpHeaderView() {
        view.addSubview(chevronImage)
        view.addSubview(headLabel)
        chevronImage.addTarget(self, action: #selector(chevronTappedd), for: .touchUpInside)
        NSLayoutConstraint.activate([
            chevronImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            chevronImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            headLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: headLabel.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func setupViews(){
        onelineView.backgroundColor = UIColor(named: "cellDb")
        secondlineView.backgroundColor = UIColor(named: "cellDb")
        thirdlineView.backgroundColor = UIColor(named: "cellDb")
        
        contentView.addSubview(howToUse)
        NSLayoutConstraint.activate([
            howToUse.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            howToUse.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            howToUse.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24),
            howToUse.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -24),
        ])
        
        contentView.addSubview(stringHowToUse)
        NSLayoutConstraint.activate([
            stringHowToUse.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stringHowToUse.topAnchor.constraint(equalTo: howToUse.bottomAnchor, constant: 16),
            stringHowToUse.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24),
            stringHowToUse.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -24),
        ])
        
        contentView.addSubview(onelineView)
        NSLayoutConstraint.activate([
            onelineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            onelineView.topAnchor.constraint(equalTo: stringHowToUse.bottomAnchor, constant: 16),
            onelineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24),
            onelineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -24),
            onelineView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        contentView.addSubview(appMeasure)
        NSLayoutConstraint.activate([
            appMeasure.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            appMeasure.topAnchor.constraint(equalTo: onelineView.bottomAnchor, constant: 16),
            appMeasure.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24),
            appMeasure.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -24),
        ])
        
        contentView.addSubview(stringMeasure)
        NSLayoutConstraint.activate([
            stringMeasure.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stringMeasure.topAnchor.constraint(equalTo: appMeasure.bottomAnchor, constant: 16),
            stringMeasure.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24),
            stringMeasure.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -24),
        ])
        
        contentView.addSubview(secondlineView)
        NSLayoutConstraint.activate([
            secondlineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            secondlineView.topAnchor.constraint(equalTo: stringMeasure.bottomAnchor, constant: 16),
            secondlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24),
            secondlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -24),
            secondlineView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        contentView.addSubview(geoLocation)
        NSLayoutConstraint.activate([
            geoLocation.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            geoLocation.topAnchor.constraint(equalTo: secondlineView.bottomAnchor, constant: 16),
            geoLocation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24),
            geoLocation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -24),
        ])
        
        contentView.addSubview(stringLocation)
        NSLayoutConstraint.activate([
            stringLocation.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stringLocation.topAnchor.constraint(equalTo: geoLocation.bottomAnchor, constant: 16),
            stringLocation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24),
            stringLocation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -24),
        ])
        
        contentView.addSubview(thirdlineView)
        NSLayoutConstraint.activate([
            thirdlineView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            thirdlineView.topAnchor.constraint(equalTo: stringLocation.bottomAnchor, constant: 16),
            thirdlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 24),
            thirdlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -24),
            thirdlineView.heightAnchor.constraint(equalToConstant: 1),
            thirdlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

extension FAQSetting {
    @objc func chevronTappedd() {
        dismiss(animated: true)
    }
}

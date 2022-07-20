//
//  FAQSetting.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 15.07.22.
//

import Foundation
import UIKit

class FAQSetting: UIViewController {
    
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
    
    lazy var scroll = UIScrollView()
    lazy var contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension FAQSetting {
    
    func setup() {
        view.addSubview(scroll)
        view.backgroundColor = UIColor(named: "backgroundColor")
        scroll.addSubview(contentView)
        contentView.addSubview(headLabel)
        view.addSubview(chevronImage)
        contentView.addSubview(howToUse)
        contentView.addSubview(onelineView)
        contentView.addSubview(secondlineView)
        contentView.addSubview(thirdlineView)
        contentView.addSubview(stringHowToUse)
        contentView.addSubview(appMeasure)
        contentView.addSubview(stringMeasure)
        contentView.addSubview(geoLocation)
        contentView.addSubview(stringLocation)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        if MTUserDefaults.shared.theme == .dark {
            onelineView.backgroundColor = .white.withAlphaComponent(0.2)
            secondlineView.backgroundColor = .white.withAlphaComponent(0.2)
            thirdlineView.backgroundColor = .white.withAlphaComponent(0.2)
        } else {
            onelineView.backgroundColor = .black.withAlphaComponent(0.2)
            secondlineView.backgroundColor = .black.withAlphaComponent(0.2)
            thirdlineView.backgroundColor = .black.withAlphaComponent(0.2)
        }
        
        chevronImage.addTarget(self, action: #selector(chevronTappedd), for: .touchUpInside)
        NSLayoutConstraint.activate([
            
            scroll.heightAnchor.constraint(equalToConstant: 1000),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scroll.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scroll.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor),
            
            headLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chevronImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            chevronImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            howToUse.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 40),
            howToUse.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            howToUse.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            stringHowToUse.topAnchor.constraint(equalTo: howToUse.bottomAnchor, constant: 16),
            stringHowToUse.leadingAnchor.constraint(equalTo: howToUse.leadingAnchor),
            stringHowToUse.trailingAnchor.constraint(equalTo: howToUse.trailingAnchor),
            
            onelineView.topAnchor.constraint(equalTo: stringHowToUse.bottomAnchor, constant: 16),
            onelineView.leadingAnchor.constraint(equalTo: stringHowToUse.leadingAnchor),
            onelineView.trailingAnchor.constraint(equalTo: stringHowToUse.trailingAnchor),
            onelineView.heightAnchor.constraint(equalToConstant: 1),
            
            appMeasure.topAnchor.constraint(equalTo: onelineView.bottomAnchor, constant: 16),
            appMeasure.leadingAnchor.constraint(equalTo: onelineView.leadingAnchor),
            appMeasure.trailingAnchor.constraint(equalTo: onelineView.trailingAnchor),
            
            stringMeasure.topAnchor.constraint(equalTo: appMeasure.bottomAnchor, constant: 16),
            stringMeasure.leadingAnchor.constraint(equalTo: appMeasure.leadingAnchor),
            stringMeasure.trailingAnchor.constraint(equalTo: appMeasure.trailingAnchor),
            
            secondlineView.topAnchor.constraint(equalTo: stringMeasure.bottomAnchor, constant: 16),
            secondlineView.leadingAnchor.constraint(equalTo: stringMeasure.leadingAnchor),
            secondlineView.trailingAnchor.constraint(equalTo: stringMeasure.trailingAnchor),
            secondlineView.heightAnchor.constraint(equalToConstant: 1),
            
            geoLocation.topAnchor.constraint(equalTo: secondlineView.bottomAnchor, constant: 16),
            geoLocation.leadingAnchor.constraint(equalTo: stringMeasure.leadingAnchor),
            geoLocation.trailingAnchor.constraint(equalTo: stringMeasure.trailingAnchor),
            
            stringLocation.topAnchor.constraint(equalTo: geoLocation.bottomAnchor, constant: 16),
            stringLocation.leadingAnchor.constraint(equalTo: geoLocation.leadingAnchor),
            stringLocation.trailingAnchor.constraint(equalTo: geoLocation.trailingAnchor),
        ])
    }
}

extension FAQSetting {
    
    @objc func chevronTappedd() {
        print("1r241412")
        dismiss(animated: true)
    }
}

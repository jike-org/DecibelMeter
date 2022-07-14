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
    
    lazy var image = UIImageView(image: UIImage(named: "chevron"))
    lazy var headLabel = Label(style: .heading, lFAQ)
    lazy var howToUse = Label(style: .heading, "How to use the application?")
    lazy var stringHowToUse = Label(style: .titleLabel, """
  The sound level meter can measure ambient noise in real time, as well as record and play recordings. For the sound level meter to work and determine the level of detected noise, open access to the microphone of your device. The sound data read by the microphone is expressed in decibels (dB).
  On the main screen, there is the current measurement and multiple controls. The big blue record button (start of measurement) is in the middle.
  MAX — a maximum value in the current measurement.
  AVG — an average value in the current measurement.
  MIN — an minimum average value in the current measurement.
  """)
    
    lazy var appMeasure = Label(style: .heading, "Why doesn't the app measure the noise level and the main screen shows zero?")
    
    lazy var stringMeasure = Label(style: .titleLabel, """
  If instead of measurements you see a zero on the main screen, then you have banned the sound level meter to access your microphone. Go to Settings > Privacy policy > Microphone and allow the program access to the microphone.
  """)
    
    lazy var geoLocation = Label(style: .heading, "Why doesn't the app store geo-location information while recording?")
    
    lazy var stringLocation = Label(style: .titleLabel, """
  If the program does not save information on geographical position during recording, it means you have banned to access to geographical location data. Go to Settings > Privacy policy > Location Services and allow the program to access the data.
  """)
    
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
    }
}

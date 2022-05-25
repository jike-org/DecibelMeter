//
//  SaveControllerInfo.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 17.05.22.
//

import Foundation
import UIKit

class SaveControllerInfo: UIViewController {
    
    //MARK: - Create UI
    // label
    lazy var mainInfoLabel = Label(style: .heading, "Record 1")
    lazy var durationLabel = Label(style: .titleLabel, "Duration:")
    lazy var locationLabel = Label(style: .titleLabel, "Location:")
    lazy var dateLabel = Label(style: .titleLabel, "Date:")
    lazy var averageLabel = Label(style: .titleLabel, "Average:")
    lazy var minLabel = Label(style: .titleLabel, "Min:")
    lazy var maxLabel = Label(style: .titleLabel, "Max:")
    
    lazy var durationValue = Label(style: .tableLabel, "12.15")
    lazy var locationValue = Label(style: .tableLabel, "Minsk")
    lazy var dateValue = Label(style: .tableLabel, "10.05.2020")
    lazy var averageValue = Label(style: .tableLabel, "68")
    lazy var minValue = Label(style: .tableLabel, "59")
    lazy var maxValue = Label(style: .tableLabel, "97")
    
    // button
    lazy var menuButton = Button(style: .link, ":")
    lazy var playPauseButton = Button(style: .playOrPause, "")
    lazy var moveNextButton = Button(style: .close, "")
    lazy var movePrevButton = Button(style: .close, "")
    lazy var backButton = Button(style: .close, "<")
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension SaveControllerInfo {
    
    func setup() {
        
        maxValue.translatesAutoresizingMaskIntoConstraints = false
        minValue.translatesAutoresizingMaskIntoConstraints = false
        averageValue.translatesAutoresizingMaskIntoConstraints = false
        dateValue.translatesAutoresizingMaskIntoConstraints = false
        locationValue.translatesAutoresizingMaskIntoConstraints = false
        durationValue.translatesAutoresizingMaskIntoConstraints = false
        mainInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        moveNextButton.translatesAutoresizingMaskIntoConstraints = false
        movePrevButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(maxValue)
        view.addSubview(minValue)
        view.addSubview(averageValue)
        view.addSubview(dateValue)
        view.addSubview(locationValue)
        view.addSubview(durationValue)
        view.addSubview(mainInfoLabel)
        view.addSubview(durationLabel)
        view.addSubview(locationLabel)
        view.addSubview(dateLabel)
        view.addSubview(averageLabel)
        view.addSubview(minLabel)
        view.addSubview(maxLabel)
        view.addSubview(menuButton)
        view.addSubview(playPauseButton)
        view.addSubview(moveNextButton)
        view.addSubview(movePrevButton)
        view.addSubview(backButton)
        
        let widthCommon = CGFloat(70)
        let heightCommon = CGFloat(20)
        
        NSLayoutConstraint.activate([
            
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 10),
            backButton.heightAnchor.constraint(equalToConstant: 10),
            
            // value
            
            durationValue.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            durationValue.topAnchor.constraint(equalTo: durationLabel.topAnchor),
            durationValue.widthAnchor.constraint(equalToConstant: widthCommon),
            durationValue.heightAnchor.constraint(equalToConstant: heightCommon),
            
            locationValue.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            locationValue.topAnchor.constraint(equalTo: durationValue.bottomAnchor, constant: 15),
            locationValue.widthAnchor.constraint(equalToConstant: widthCommon),
            locationValue.heightAnchor.constraint(equalToConstant: heightCommon),
            
            dateValue.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dateValue.topAnchor.constraint(equalTo: locationValue.bottomAnchor, constant: 15),
            dateValue.widthAnchor.constraint(equalToConstant: 90),
            dateValue.heightAnchor.constraint(equalToConstant: heightCommon),
            
            averageValue.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            averageValue.topAnchor.constraint(equalTo: dateValue.bottomAnchor, constant: 15),
            averageValue.widthAnchor.constraint(equalToConstant: widthCommon),
            averageValue.heightAnchor.constraint(equalToConstant: heightCommon),
            
            minValue.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            minValue.topAnchor.constraint(equalTo: averageValue.bottomAnchor, constant: 15),
            minValue.widthAnchor.constraint(equalToConstant: widthCommon),
            minValue.heightAnchor.constraint(equalToConstant: heightCommon),
            
            maxValue.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            maxValue.topAnchor.constraint(equalTo: minValue.bottomAnchor, constant: 15),
            maxValue.widthAnchor.constraint(equalToConstant: widthCommon),
            maxValue.heightAnchor.constraint(equalToConstant: heightCommon),
            
            
            // main ui
            mainInfoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainInfoLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 70),
            mainInfoLabel.widthAnchor.constraint(equalToConstant: 90),
            mainInfoLabel.heightAnchor.constraint(equalToConstant: 40),
            
            durationLabel.topAnchor.constraint(equalTo: mainInfoLabel.bottomAnchor, constant: 50),
            durationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            durationLabel.widthAnchor.constraint(equalToConstant: widthCommon),
            durationLabel.heightAnchor.constraint(equalToConstant: heightCommon),
            
            locationLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            locationLabel.widthAnchor.constraint(equalToConstant: widthCommon),
            locationLabel.heightAnchor.constraint(equalToConstant: heightCommon),
            
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: widthCommon),
            dateLabel.heightAnchor.constraint(equalToConstant: heightCommon),
            
            averageLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
            averageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            averageLabel.widthAnchor.constraint(equalToConstant: widthCommon),
            averageLabel.heightAnchor.constraint(equalToConstant: heightCommon),
            
            minLabel.topAnchor.constraint(equalTo: averageLabel.bottomAnchor, constant: 15),
            minLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            minLabel.widthAnchor.constraint(equalToConstant: widthCommon),
            minLabel.heightAnchor.constraint(equalToConstant: heightCommon),
            
            maxLabel.topAnchor.constraint(equalTo: minLabel.bottomAnchor, constant: 15),
            maxLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            maxLabel.widthAnchor.constraint(equalToConstant: widthCommon),
            maxLabel.heightAnchor.constraint(equalToConstant: heightCommon),

        ])
    }
}

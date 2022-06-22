//
//  CustomSaveCell.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 27.05.22.
//

import Foundation
import UIKit
import SwipeCellKit

class CustomSaveCell: SwipeCollectionViewCell {
    
    static let id = "CustomSaveCell"
    
    // MARK: UI elements
    lazy var playButton = Button(style: .playOrPauseCell, nil)
    
    var buttonTag: UUID? {
        return playButton.uuid
    }

    private lazy var recordName = Label(style: .recordCell, "Record name")
    private lazy var dateName = Label(style: .cellDate, "26.05.2022")
    private lazy var soundTime = Label(style: .cellDate, "00:15")
    private lazy var min = Label(style: .minMaxAvgCell, "MIN 20")
    private lazy var max = Label(style: .minMaxAvgCell, "MAX 75")
    private lazy var avg = Label(style: .minMaxAvgCell, "AVG 82")
    
    // MARK: Player instance
    private var player: Player!
    
    public var audioID: UUID!
    var isPlaying: Bool = false
    
    public func setValues(
        name: String,
        time: String,
        min: String,
        max: String,
        avg: String
    ) {
        self.recordName.text = name
        self.soundTime.text = time
        self.min.text = min
        self.max.text = max
        self.avg.text = avg
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemGray
        contentView.addSubview(playButton)
        contentView.addSubview(min)
        contentView.addSubview(max)
        contentView.addSubview(avg)
        contentView.addSubview(soundTime)
        contentView.addSubview(dateName)
        contentView.addSubview(recordName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("ini coder ne rabotaet")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        soundTime.textAlignment = .left
        recordName.textAlignment = .left
        recordName.textColor = UIColor(named: "saveCell")
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            
            dateName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateName.widthAnchor.constraint(equalToConstant: 85),
            dateName.heightAnchor.constraint(equalToConstant: 15),
        
            recordName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            recordName.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 25),
            recordName.trailingAnchor.constraint(equalTo: dateName.leadingAnchor, constant: 10),
            
            soundTime.topAnchor.constraint(equalTo: recordName.bottomAnchor, constant: 11),
            soundTime.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 25),
            soundTime.widthAnchor.constraint(equalToConstant: 46),
            soundTime.heightAnchor.constraint(equalToConstant: 15),
            
            min.topAnchor.constraint(equalTo: recordName.bottomAnchor, constant: 11),
            min.leadingAnchor.constraint(equalTo: soundTime.trailingAnchor, constant: 30),
            min.widthAnchor.constraint(equalToConstant: 46),
            min.heightAnchor.constraint(equalToConstant: 15),
            
            avg.topAnchor.constraint(equalTo: recordName.bottomAnchor, constant: 11),
            avg.trailingAnchor.constraint(equalTo: max.leadingAnchor, constant: -40),
            avg.widthAnchor.constraint(equalToConstant: 46),
            avg.heightAnchor.constraint(equalToConstant: 15),
            
            max.topAnchor.constraint(equalTo: recordName.bottomAnchor, constant: 11),
            max.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            max.widthAnchor.constraint(equalToConstant: 46),
            max.heightAnchor.constraint(equalToConstant: 15),
      
        ])
    }
    
}

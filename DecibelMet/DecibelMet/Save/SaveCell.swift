////
////  SaveController.swift
////  DecibelMet
////
////  Created by Stas Dashkevich on 5.05.22.
////
//import UIKit
//
//
//class SavedCell: UITableViewCell {
//
//    // MARK: UI elements
//    lazy var playButton = Button(style: .playOrPause, nil)
//
//    var buttonTag: UUID? {
//        return playButton.uuid
//    }
//
//    private lazy var recordName = Label(style: .tableTopText, "record name")
//    private lazy var dateName = Label(style: .tableBottomText, "26.05.2022")
//    private lazy var soundTime = Label(style: .tableBottomText, "0:15")
//    private lazy var min = Label(style: .tableBottomText, "MIN 20")
//    private lazy var max = Label(style: .tableBottomText, "MAX 75")
//    private lazy var avg = Label(style: .tableBottomText, "AVG 82")
//
//    // MARK: Player instance
//    private var player: Player!
//    
//    public var audioID: UUID!
//    var isPlaying: Bool = false
//
//    public func setValues(
//        name: String,
//        time: String,
//        min: String,
//        max: String,
//        avg: String
//    ) {
//        self.recordName.text = name
//        self.soundTime.text = time
//
//        self.min.text = min
//        self.max.text = max
//        self.avg.text = avg
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .default, reuseIdentifier: reuseIdentifier)
//
//        let selectionBackground = UIView()
//        selectionBackground.backgroundColor = .secondarySystemBackground
//        selectedBackgroundView = selectionBackground
//
//        backgroundColor = .red
//        addSubview(recordName)
//        addSubview(min)
//        addSubview(max)
//        addSubview(avg)
//        addSubview(soundTime)
//        addSubview(dateName)
//        addSubview(playButton)
//
//        playButton.translatesAutoresizingMaskIntoConstraints = false
//        recordName.translatesAutoresizingMaskIntoConstraints = false
//        min.translatesAutoresizingMaskIntoConstraints = false
//        max.translatesAutoresizingMaskIntoConstraints = false
//        avg.translatesAutoresizingMaskIntoConstraints = false
//        soundTime.translatesAutoresizingMaskIntoConstraints = false
//        dateName.translatesAutoresizingMaskIntoConstraints = false
//
//        let constraints = [
//
//            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//
//            dateName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
//            dateName.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//
//            recordName.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 34),
//            recordName.topAnchor.constraint(equalTo: topAnchor, constant: 16),
//            recordName.trailingAnchor.constraint(equalTo: dateName.leadingAnchor),
//
//            min.topAnchor.constraint(equalTo: recordName.bottomAnchor, constant: 6),
//            min.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16),
//            min.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 34),
//
//            avg.topAnchor.constraint(equalTo: recordName.bottomAnchor, constant: 6),
//            avg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16),
//            avg.leadingAnchor.constraint(equalTo: min.trailingAnchor, constant: 22),
//
//            max.topAnchor.constraint(equalTo: recordName.bottomAnchor, constant: 6),
//            max.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16),
//            max.leadingAnchor.constraint(equalTo: avg.trailingAnchor, constant: 22),
//
//        ]
//
//        NSLayoutConstraint.activate(constraints)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//

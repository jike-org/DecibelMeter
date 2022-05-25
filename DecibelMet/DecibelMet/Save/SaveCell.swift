//
//  SaveController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 5.05.22.
//
import UIKit


class SavedCell: UITableViewCell {
    
    // MARK: UI elements
    lazy var playButton = Button(style: .playOrPause, nil)
    
    var buttonTag: UUID? {
        return playButton.uuid
    }
    
    private lazy var stack       = StackView(axis: .vertical)
    
    private lazy var topStack    = StackView(axis: .horizontal)
    private lazy var soundName   = Label(style: .tableTopText, "26.01.2022, 20:43")
    
    private lazy var topPodstack = StackView(axis: .horizontal)
    private lazy var timeIcon    = ImageView(image: .rate)
    private lazy var timeLabel   = Label(style: .tableTopText, "01:25")
    
    private lazy var bottomStack = StackView(axis: .horizontal)
    private lazy var min         = Label(style: .tableBottomText, "MIN 20")
    private lazy var max         = Label(style: .tableBottomText, "MAX 75")
    private lazy var avg         = Label(style: .tableBottomText, "AVG 82")
    
    private lazy var chevron = ImageView(image: .rate)
    
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
        self.soundName.text = name
        self.timeLabel.text = time
        
        self.min.text = min
        self.max.text = max
        self.avg.text = avg
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        let selectionBackground = UIView()
        selectionBackground.backgroundColor = .clear
        selectedBackgroundView = selectionBackground
        
        stack.distribution = .fill
        timeIcon.frame.size.height = 10
        timeIcon.frame.size.width = 10
        
        contentView.addSubview(playButton)
        
        addSubview(stack)
        
        stack.addArrangedSubview(topStack)
        topStack.addArrangedSubview(soundName)
        topStack.addArrangedSubview(topPodstack)
        topPodstack.addArrangedSubview(timeIcon)
        topPodstack.addArrangedSubview(timeLabel)
        
        stack.addArrangedSubview(bottomStack)
        bottomStack.addArrangedSubview(min)
        bottomStack.addArrangedSubview(max)
        bottomStack.addArrangedSubview(avg)
        
        topPodstack.setCustomSpacing(5, after: timeIcon)
        
        addSubview(chevron)
        
        chevron.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            stack.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 13),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -13),
            stack.heightAnchor.constraint(equalToConstant: 30),
            
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevron.heightAnchor.constraint(equalToConstant: 15),
            chevron.widthAnchor.constraint(equalToConstant: 9)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


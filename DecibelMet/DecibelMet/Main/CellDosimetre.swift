//
//  CellDosimetre.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 27.07.22.
//

import Foundation
import UIKit
import Combine

class CellDosimetre: UICollectionViewCell {
    
    static let id = "DowimeterCellbjk"
    
    // MARK: UI elements
    lazy var timeTitle = Label(style: .time, "MAX: 10 min 58 sec")
    lazy var dbTitel = Label(style: .dbTitel, "115")
    lazy var dbImage = Label(style: .dbImage, "dB")
    var procent = Label(style: .time, "100%")
    lazy var time = Label(style: .time, "00:00")
    lazy var viewColor: UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3
        return view
    }()
    
    // MARK: Player instance
    private var player: Player!
    
    public var audioID: UUID!
    var isPlaying: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(timeTitle)
        contentView.addSubview(dbTitel)
        contentView.addSubview(dbImage)
        contentView.addSubview(procent)
        contentView.addSubview(time)
        contentView.addSubview(viewColor)
        
        if UIScreen.main.bounds.height > 700 {
            NSLayoutConstraint.activate([

                timeTitle.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
                timeTitle.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,constant: 15),
                timeTitle.heightAnchor.constraint(equalToConstant: 20),
                timeTitle.widthAnchor.constraint(equalToConstant: 130),
                
                dbTitel.topAnchor.constraint(equalTo: timeTitle.bottomAnchor,constant: 5),
                dbTitel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
                dbTitel.heightAnchor.constraint(equalToConstant: 20),
                dbTitel.widthAnchor.constraint(equalToConstant: 30),
                
                dbImage.topAnchor.constraint(equalTo: timeTitle.bottomAnchor,constant: -1),
                dbImage.leadingAnchor.constraint(equalTo: dbTitel.trailingAnchor, constant: -4),
                dbImage.heightAnchor.constraint(equalToConstant: 20),
                dbImage.widthAnchor.constraint(equalToConstant: 30),
                
                procent.topAnchor.constraint(equalTo: timeTitle.topAnchor, constant: 5),
                procent.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                
                time.topAnchor.constraint(equalTo: timeTitle.topAnchor, constant: 5),
                time.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                
                viewColor.topAnchor.constraint(equalTo: dbTitel.bottomAnchor, constant: -12),
                viewColor.leadingAnchor.constraint(equalTo: dbImage.trailingAnchor, constant: 5),
                viewColor.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                viewColor.heightAnchor.constraint(equalToConstant: 5)
            ])

        } else {
            NSLayoutConstraint.activate([

                timeTitle.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 1),
                timeTitle.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,constant: 15),
                timeTitle.heightAnchor.constraint(equalToConstant: 20),
                timeTitle.widthAnchor.constraint(equalToConstant: 130),
                
                dbTitel.topAnchor.constraint(equalTo: timeTitle.bottomAnchor,constant: 2),
                dbTitel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 15),
                dbTitel.heightAnchor.constraint(equalToConstant: 20),
                dbTitel.widthAnchor.constraint(equalToConstant: 30),
                
                dbImage.topAnchor.constraint(equalTo: timeTitle.bottomAnchor,constant: -1),
                dbImage.leadingAnchor.constraint(equalTo: dbTitel.trailingAnchor, constant: -4),
                dbImage.heightAnchor.constraint(equalToConstant: 20),
                dbImage.widthAnchor.constraint(equalToConstant: 30),
                
                procent.topAnchor.constraint(equalTo: timeTitle.topAnchor, constant: 5),
                procent.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                
                time.topAnchor.constraint(equalTo: timeTitle.topAnchor, constant: 5),
                time.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                
                viewColor.topAnchor.constraint(equalTo: dbTitel.topAnchor, constant: 5),
                viewColor.leadingAnchor.constraint(equalTo: dbImage.trailingAnchor, constant: 5),
                viewColor.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
                viewColor.heightAnchor.constraint(equalToConstant: 5)
            ])

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder ne rabotaet")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subscriptions.removeAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeTitle.textAlignment = .left
        timeTitle.layer.opacity = 0.7
        procent.layer.opacity = 0.7
        time.layer.opacity = 0.7
        viewColor.backgroundColor = .systemGray
    }
    
    func configure(item: ItemOsha) {
        procent.text = String(item.procent)
        dbTitel.text = String(item.db)
        timeTitle.text = item.timeTitle
        item
            .timeEvent
            .compactMap { $0[item.db] }
            .map {
                let minutes = (Int($0) - (Int($0) % 60)) / 60
                let seconds = Int($0) - (minutes * 60)
                
                let strMinutes: String
                let strSeconds: String
                
                if minutes <= 9 {
                    strMinutes = "0\(minutes)"
                } else {
                    strMinutes = "\(minutes)"
                }
                
                if seconds <= 9 {
                    strSeconds = "0\(seconds)"
                } else {
                    strSeconds = "\(seconds)"
                }
                
               let d = "\(strMinutes):\(strSeconds)"
                return d
                
            }
            .assign(to: \.text, on: time)
            .store(in: &subscriptions)
    }
}

extension CellDosimetre {
    struct ItemOsha {
        let db: Int
        let timeTitle: String
        let timeEvent: AnyPublisher<[Int: Double], Never>
        let procent: String
    }
}

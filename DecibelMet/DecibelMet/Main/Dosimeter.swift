//
//  Dosimetr.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 30.05.22.
//

import UIKit
import KDCircularProgress
import CoreData
import AVFAudio
import Combine

final class Dosimeter: UIViewController {
    
    private var collection: UICollectionView?
    private var isTap = false
    private var isRecording = true
    private let timeValueSubject = CurrentValueSubject<[Int: Int], Never>([:])
    private var totalPrecent = 0
    private var precent90 = 0
    
    private var precent95 = 0
    private var precent100 = 0
    private var precent105 = 0
    private var precent110 = 0
    private var precent115 = 0
    private var precent120 = 0
    private var precent125 = 0
    private var precent130 = 0
     
    var second = NSLocalizedString("Second", comment: "")
    var hour = NSLocalizedString("Hour", comment: "")
    var minute = NSLocalizedString("Minute", comment: "")
    var max = NSLocalizedString("Maximum", comment: "")
    //MARK: - Audio recorder / resist
    let recorder = Recorder()
    let persist = Persist()
    var info: RecordInfo!
    
    //MARK: - UI elements
    lazy var headerLabel = Label(style: .dosimeterHeader, NSLocalizedString("Dosimeter", comment: ""))
    lazy var timeLabel = Label(style: .dosimetreTime, "00:00")
    lazy var procentLabel = Label(style: .dosimetreProcentLabel, "0")
    lazy var procentImage = Label(style: .dosimetreProcentImage, "%")
    lazy var decibelLabel = Label(style: .dosimetreDecibelLabel, "132")
    lazy var dbImage = Label(style: .dosimetredb, "dB")
    lazy var refreshButton = Button(style: .refresh, nil)
    lazy var noiseButton = Button(style: .noise, "NOISE")
    lazy var progress = KDCircularProgress(
        frame: CGRect(x: 0, y: 0, width: view.frame.width / 1.2, height: view.frame.width / 1.2)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        recorder.delegate = self
        recorder.avDelegate = self
        setup()
        setUpCollection()
        requestPermissions()
        startRecordingAudio()
        isRecording = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    private func requestPermissions() {
        if !Constants().isFirstLaunch {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in }
            Constants().isFirstLaunch = true
        }
    }
}

extension Dosimeter {
    
    func setUpCollection() {
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.size.width) - 15, height: 60)
        layout.minimumLineSpacing = 6
        collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        guard let collection = collection else { return }
        
        collection.register(DosimeterCell.self, forCellWithReuseIdentifier: DosimeterCell.id)
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor(named: "backgroundColor")
        collection.indicatorStyle = .black
        view.addSubview(collection)
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: noiseButton.bottomAnchor, constant: 30),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
}

extension Dosimeter: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    var items: [DosimeterCell.Item] {
        [
            .init(db: 130, timeTitle: "\(max) 1 \(minute) 52 \(second)", timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent130)%"),
            .init(db: 125, timeTitle: "\(max) 3 \(minute) 45 \(second)", timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent125)%"),
            .init(db: 120, timeTitle: "\(max) 7 \(minute) 30 \(second)", timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent120)%"),
            .init(db: 115, timeTitle: "\(max) 15 \(minute)", timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent115)%"),
            .init(db: 110, timeTitle: "\(max) 30 \(minute)", timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent110)%"),
            .init(db: 105, timeTitle: max + " 1 " + hour, timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent105)%"),
            .init(db: 100, timeTitle: max + " 2 " + hour, timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent100)%"),
            .init(db: 95, timeTitle:  max + " 3 " + hour,  timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent95)%"),
            .init(db: 90, timeTitle:  max + " 4 " + hour,  timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent90)%"),
        ]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DosimeterCell.id, for: indexPath) as! DosimeterCell
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor(named: "backCell")
        cell.configure(item: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = collectionView.cellForItem(at: indexPath)
        selectedItem?.layer.borderColor = UIColor.red.cgColor
        print(1)
    }
}

extension Dosimeter {
    
    private func startRecordingAudio() {
        recorder.record(self)
        recorder.startMonitoring()
    }
}

//MARK: - Constreint Set Up
extension Dosimeter {
    
    private func setup() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        noiseButton.setTitle("NOISE", for: .normal)
        noiseButton.backgroundColor = UIColor(named: "nosha")
        noiseButton.setTitleColor(UIColor(named: "noshaTitle"), for: .normal)
        noiseButton.addTarget(self, action: #selector(noiseTap), for: .touchUpInside)
        setupCircleView()
        view.addSubview(headerLabel)
        view.addSubview(progress)
        view.addSubview(timeLabel)
        view.addSubview(procentLabel)
        view.addSubview(procentImage)
        view.addSubview(decibelLabel)
        view.addSubview(dbImage)
        view.addSubview(refreshButton)
        view.addSubview(noiseButton)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.bottomAnchor.constraint(equalTo: progress.topAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: progress.topAnchor, constant: 115),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            procentLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 2),
            procentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            procentImage.topAnchor.constraint(equalTo: timeLabel.bottomAnchor),
            procentImage.leadingAnchor.constraint(equalTo: procentLabel.trailingAnchor),
            
            decibelLabel.topAnchor.constraint(equalTo: procentLabel.bottomAnchor),
            decibelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dbImage.leadingAnchor.constraint(equalTo: decibelLabel.trailingAnchor),
            dbImage.topAnchor.constraint(equalTo: procentLabel.bottomAnchor),
            
            refreshButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            refreshButton.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: -60),
            
            noiseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            noiseButton.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: -60)
        ])
    }
}

extension Dosimeter {
    
    @objc func noiseTap() {
        if isTap {
            noiseButton.setTitle("NOISE", for: .normal)
            noiseButton.backgroundColor = UIColor(named: "nosha")
            noiseButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
            isTap = false
        } else {
            noiseButton.setTitle("OSHA", for: .normal)
            noiseButton.backgroundColor = #colorLiteral(red: 0.137247622, green: 0, blue: 0.956287086, alpha: 1)
            noiseButton.setTitleColor(UIColor.white, for: .normal)
            isTap = true
        }
    }
}
// MARK: Setup circle view
extension Dosimeter {
    
    private func setupCircleView() {
        progress.startAngle = -150
        progress.progressThickness = 0.6
        progress.trackThickness = 0.7
        progress.clockwise = true
        progress.glowMode = .noGlow
        progress.trackColor = UIColor(named: "backCircleDosimetre")!
        progress.set(colors:UIColor.green,UIColor.yellow,UIColor.yellow, UIColor.orange)
        progress.center = CGPoint(x: view.center.x, y: view.center.y / 1.8)
    }
}

extension Dosimeter: AVAudioRecorderDelegate, RecorderDelegate {
    
    func recorder(_ recorder: Recorder, didFinishRecording info: RecordInfo) {
        // FIXME: Unusual
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Record finished")
        // FIXME: Unusual
    }
    
    func recorderDidFailToAchievePermission(_ recorder: Recorder) {
        let alertController = UIAlertController(title: "Microphone permissions denied", message: "Microphone permissions have been denied for this app. You can change this by going to Settings", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let settingButton = UIAlertAction(title: "Settings", style: .default) { _
            in
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!,
                options: [:],
                completionHandler: nil)
        }
        
        alertController.addAction(cancelButton)
        alertController.addAction(settingButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func recorder(_ recorder: Recorder, didCaptureDecibels decibels: Int) {
        let degree = 360/96
        let minutes = (recorder.seconds - (recorder.seconds % 60)) / 60
        let seconds = recorder.seconds - (minutes * 60)
        
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
        
        var timeDict = timeValueSubject.value
        func increaseDictValue(_ dict: inout [Int: Int], key: Int) {
            let value = dict[key]
            dict[key] = value == nil ? 1 : value! + 1
        }
        if (90..<95).contains(decibels) {
            increaseDictValue(&timeDict, key: 95)
            precent90 = Int((timeDict[95]!) / 14400 * 100)
            
            procentLabel.text = String(totalPrecent)
        }
        if (95..<100).contains(decibels) {
            increaseDictValue(&timeDict, key: 100)
        }
        if (100..<105).contains(decibels) {
            increaseDictValue(&timeDict, key: 105)
        }
        if (105..<110).contains(decibels) {
            increaseDictValue(&timeDict, key: 110)
        }
        if (110..<115).contains(decibels) {
            increaseDictValue(&timeDict, key: 115)
        }
        if (115..<120).contains(decibels) {
            increaseDictValue(&timeDict, key: 120)
        }
        if (120..<125).contains(decibels) {
            increaseDictValue(&timeDict, key: 125)
        }
        if (125..<130).contains(decibels) {
            increaseDictValue(&timeDict, key: 130)
        }
        if (130..<200).contains(decibels) {
            increaseDictValue(&timeDict, key: 200)
        }
        totalPrecent = (Int(precent90))
        timeValueSubject.send(timeDict)
        timeLabel.text = "\(strMinutes): \(strSeconds)"
        decibelLabel.text = "\(decibels)"
        progress.animate(toAngle: Double(degree * decibels), duration: 0.7, completion: nil)
    }
}

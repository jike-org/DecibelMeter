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
    private let timeValueSubject = CurrentValueSubject<[Int: Double], Never>([:])
    
    var timer: Timer?
    var timer1: Timer?
    var runCount1 = 0.0
    var runCount2 = 0.0
    var runCount3 = 0.0
    
    //MARK: - Audio recorder / resist
    let recorder = Recorder()
    let persist = Persist()
    var info: RecordInfo!
    
    //MARK: - UI elements
    lazy var headerLabel = Label(style: .dosimeterHeader, "DOSIMETER")
    lazy var timeLabel = Label(style: .dosimetreTime, "00:00")
    lazy var procentLabel = Label(style: .dosimetreProcentLabel, "72.5")
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
        recorder.delegate = self
        recorder.avDelegate = self
        
        tabBarController?.tabBar.isHidden = false
        setup()
        setUpCollection()
        requestPermissions()
        startRecordingAudio()
        
    }
    
    private func requestPermissions() {
        if !Constants().isFirstLaunch {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in }
            Constants().isFirstLaunch = true
        }
    }
    
    func test() {
        print ("490uy1pu41")
    }
}

extension Dosimeter {
    
    func setUpCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.size.width) - 15, height: 60)
        layout.minimumLineSpacing = 6
        collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        
        guard let collection = collection else { return }
        
        collection.register(DosimeterCell.self, forCellWithReuseIdentifier: DosimeterCell.id)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .black
        collection.translatesAutoresizingMaskIntoConstraints = false
        
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
            .init(db: 130, timeTitle: "MAX 1 min 52 sec", timeEvent: timeValueSubject.eraseToAnyPublisher()),
            .init(db: 120, timeTitle: "MAX 1 min 53 sec", timeEvent: timeValueSubject.eraseToAnyPublisher()),
            .init(db: 110, timeTitle: "MAX 1 min 54 sec", timeEvent: timeValueSubject.eraseToAnyPublisher()),
            .init(db: 100, timeTitle: "MAX 1 min 55 sec", timeEvent: timeValueSubject.eraseToAnyPublisher()),
            .init(db: 90, timeTitle: "MAX 1 min 56 sec", timeEvent: timeValueSubject.eraseToAnyPublisher()),
            .init(db: 80, timeTitle: "MAX 1 min 57 sec", timeEvent: timeValueSubject.eraseToAnyPublisher()),
            .init(db: 70, timeTitle: "MAX 1 min 58 sec", timeEvent: timeValueSubject.eraseToAnyPublisher()),
            .init(db: 60, timeTitle: "MAX 1 min 59 sec", timeEvent: timeValueSubject.eraseToAnyPublisher()),
            .init(db: 50, timeTitle: "MAX 1 min 59 sec", timeEvent: timeValueSubject.eraseToAnyPublisher()),
            .init(db: 40, timeTitle: "MAX 1 min 59 sec", timeEvent: timeValueSubject.eraseToAnyPublisher())
        ]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DosimeterCell.id, for: indexPath) as! DosimeterCell
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.contentView.backgroundColor = #colorLiteral(red: 0.1490753889, green: 0.1489614546, blue: 0.1533248723, alpha: 1)
        cell.configure(item: items[indexPath.row])
        
//        switch indexPath.row {
//        case 0:
//            cell.dbTitel.text = "130"
//            cell.timeTitle.text = "MAX 1 min 52 sec"
//            if recorder.getDecibels() > 40 && recorder.getDecibels() < 50 {
//                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [unowned self] timer in
//                    print("Timer fired!")
//                    runCount1 += 1
//                    timer.tolerance = 0.2
//                    cell.time.text = "\(runCount1)"
//                    if runCount1 == 20 {
//                        timer.invalidate()
//                    }
//                }
//            } else {
//                cell.time.text = String(runCount1)
//            }
//        case 1:
//            cell.dbTitel.text = "125"
//            cell.timeTitle.text = "MAX 3 min 45 sec"
//            if recorder.getDecibels() > 51 && recorder.getDecibels() < 60 {
//                timer1 = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [unowned self] timer in
//                    print("Timer fired!")
//                    runCount2 += 1
//                    timer.tolerance = 0.2
//                    cell.time.text = "\(runCount2)"
//                    if runCount2 == 20 {
//                        timer.invalidate()
//                    }
//                }
//            } else {
//                cell.time.text = String(runCount2)
//            }
//
//
//        case 2:
//            cell.dbTitel.text = "120"
//            cell.timeTitle.text = "MAX 7 min 30 sec"
//            if recorder.getDecibels() > 61 && recorder.getDecibels() < 70 {
//                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [unowned self] timer in
//                    print("Timer fired!")
//                    runCount3 += 1
//                    timer.tolerance = 0.2
//                    cell.time.text = "\(runCount3)"
//                    if runCount3 == 20 {
//                        timer.invalidate()
//                    }
//                }
//            } else {
//                cell.time.text = String(runCount3)
//            }
//
//
//
//        case 3:
//            cell.dbTitel.text = "115"
//            cell.timeTitle.text = "MAX 15 min 00 sec"
//            if recorder.getDecibels() > 80 && recorder.getDecibels() < 90 {
//                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [unowned self] timer in
//                    print("Timer fired!")
//                    runCount3 += 1
//                    timer.tolerance = 0.2
//                    cell.time.text = "\(runCount3)"
//                    if runCount3 == 20 {
//                        timer.invalidate()
//                    }
//                }
//            } else {
//                cell.time.text = String(runCount3)
//            }
//
//
//
//        case 4:
//            cell.dbTitel.text = "110"
//            cell.timeTitle.text = "MAX 30 min 00 sec"
//            if recorder.getDecibels() > 61 && recorder.getDecibels() < 70 {
//                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [unowned self] timer in
//                    print("Timer fired!")
//                    runCount3 += 1
//                    timer.tolerance = 0.2
//                    cell.time.text = "\(runCount3)"
//                    if runCount3 == 20 {
//                        timer.invalidate()
//                    }
//                }
//            } else {
//                cell.time.text = String(runCount3)
//            }
//
//
//
//        case 5:
//            cell.dbTitel.text = "105"
//            cell.timeTitle.text = "MAX 60 min 00 sec"
//            if recorder.getDecibels() > 61 && recorder.getDecibels() < 70 {
//                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [unowned self] timer in
//                    print("Timer fired!")
//                    runCount3 += 1
//                    timer.tolerance = 0.2
//                    cell.time.text = "\(runCount3)"
//                    if runCount3 == 20 {
//                        timer.invalidate()
//                    }
//                }
//            } else {
//                cell.time.text = String(runCount3)
//            }
//
//
//
//        case 6:
//            cell.dbTitel.text = "100"
//            cell.timeTitle.text = "MAX 2 hour"
//            if recorder.getDecibels() > 61 && recorder.getDecibels() < 70 {
//                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [unowned self] timer in
//                    print("Timer fired!")
//                    runCount3 += 1
//                    timer.tolerance = 0.2
//                    cell.time.text = "\(runCount3)"
//                    if runCount3 == 20 {
//                        timer.invalidate()
//                    }
//                }
//            } else {
//                cell.time.text = String(runCount3)
//            }
//
//
//
//        case 7:
//            cell.dbTitel.text = "95"
//            cell.timeTitle.text = "MAX 4 hour"
//            if recorder.getDecibels() > 61 && recorder.getDecibels() < 70 {
//                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [unowned self] timer in
//                    print("Timer fired!")
//                    runCount3 += 1
//                    timer.tolerance = 0.2
//                    cell.time.text = "\(runCount3)"
//                    if runCount3 == 20 {
//                        timer.invalidate()
//                    }
//                }
//            } else {
//                cell.time.text = String(runCount3)
//            }
//
//
//
//        case 8:
//            cell.dbTitel.text = "90"
//            cell.timeTitle.text = "MAX 8 hour"
//            if recorder.getDecibels() > 61 && recorder.getDecibels() < 70 {
//                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [unowned self] timer in
//                    print("Timer fired!")
//                    runCount3 += 1
//                    timer.tolerance = 0.2
//                    cell.time.text = "\(runCount3)"
//                    if runCount3 == 20 {
//                        timer.invalidate()
//                    }
//                }
//            } else {
//                cell.time.text = String(runCount3)
//            }
//
//        default:
//            break
//        }
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
        noiseButton.setTitle("NOISE", for: .normal)
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
            
            refreshButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            refreshButton.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: -60),
            
            noiseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noiseButton.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: -60)
            
            
        ])
    }
}

extension Dosimeter {
    
    @objc func noiseTap() {
        if isTap {
            noiseButton.setTitle("NOISE", for: .normal)
            noiseButton.backgroundColor = #colorLiteral(red: 0.1608400345, green: 0.1607262492, blue: 0.1650899053, alpha: 1)
            isTap = false
        } else {
            noiseButton.setTitle("OSHA", for: .normal)
            noiseButton.backgroundColor = #colorLiteral(red: 0.137247622, green: 0, blue: 0.956287086, alpha: 1)
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
        progress.trackColor = #colorLiteral(red: 0.1012228802, green: 0.1059223041, blue: 0.1145466045, alpha: 1)
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
        func increaseDictValue(_ dict: inout [Int: Double], key: Int) {
            let value = dict[key]
            dict[key] = value == nil ? 0.5 : value! + 0.5
        }
        
        if (0..<40).contains(decibels) {
            increaseDictValue(&timeDict, key: 40)
        }
        if (40..<50).contains(decibels) {
            increaseDictValue(&timeDict, key: 50)
        }
        if (50..<60).contains(decibels) {
            increaseDictValue(&timeDict, key: 60)
        }
        if (60..<70).contains(decibels) {
            increaseDictValue(&timeDict, key: 70)
        }
        if (70..<80).contains(decibels) {
            increaseDictValue(&timeDict, key: 80)
        }
        if (80..<90).contains(decibels) {
            increaseDictValue(&timeDict, key: 90)
        }

        timeValueSubject.send(timeDict)
        timeLabel.text = "\(strMinutes): \(strSeconds)"
        decibelLabel.text = "\(decibels)"
        progress.animate(toAngle: Double(degree * decibels), duration: 0.7, completion: nil)
    }
}

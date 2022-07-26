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
import FirebaseRemoteConfig

final class Dosimeter: UIViewController {
    
    let remoteConfig = RemoteConfig.remoteConfig()
    private var collection: UICollectionView?
    private var isTap = false
    private var isRecording = true
    private let timeValueSubject = CurrentValueSubject<[Int: Double], Never>([:])
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
    
    var defaults = UserDefaults.standard
    var flag = false
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
    
    lazy var freeDosimeter: Int = 5
    lazy var showVc = "1"
    var t = -2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
        recorder.delegate = self
        recorder.avDelegate = self
        setup()
        setUpCollection()
        startRecordingAudio()
        remote()
        
        if defaults.string(forKey: "dosimeter") == nil {
            defaults.set(t, forKey: "dosimeter")
        }
        
        t = Int(defaults.string(forKey: "dosimeter")!)!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        t += 1
        defaults.set(t, forKey: "dosimeter")
        headerLabel.text = defaults.string(forKey: "dosimeter")
        
        if Int(defaults.string(forKey: "dosimeter")!)! >= freeDosimeter {
            recorder.stopMonitoring()
            recorder.stop()
            progress.startAngle = -150
            procentLabel.text = "0"
            decibelLabel.text = "0"
            timeLabel.text = "00:00"
            
            callPurchase()
        }
    }
    
    private func requestPermissions() {
        if !Constants().isFirstLaunch {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in }
            Constants().isFirstLaunch = true
        }
    }
}

extension Dosimeter {
    
    func remote() {
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
        
        remoteConfig.fetchAndActivate { (status, error) in
            
            if error !=  nil {
                print(error?.localizedDescription)
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["availableFreeDosimeter"].stringValue {
                        self.freeDosimeter = Int(stringValue)!
                        print(self.freeDosimeter)
                    }
                    if let stringValue1 =
                        self.remoteConfig["otherScreenNumber"].stringValue {
                        self.showVc = (stringValue1)
                    }
                }
            }
        }
    }
    
    func callPurchase() {
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [self] Timer in
            if showVc == "1"{
                let vcTwo = SubscribeTwoView()
                vcTwo.modalPresentationStyle = .fullScreen
                present(vcTwo, animated: true, completion: nil)
            } else if showVc == "2" {
                let vcTrial = TrialSubscribe()
                vcTrial.modalPresentationStyle = .fullScreen
                present(vcTrial, animated: true, completion: nil)
            } else if showVc == "3" {
                let vcTrial = TrialViewController()
                vcTrial.modalPresentationStyle = .fullScreen
                present(vcTrial, animated: true, completion: nil)
            }
        })
    }
    
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
            .init(db: 95, timeTitle:  max + " 4 " + hour,  timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent95)%"),
            .init(db: 90, timeTitle:  max + " 8 " + hour,  timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent90)%"),
        ]
    }
    
    var itemNiosh: [DosimeterCell.Item] {
        [
            .init(db: 116, timeTitle: "\(max) 1 \(minute) 52 \(second)", timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent130)%"),
            .init(db: 113, timeTitle: "\(max) 3 \(minute) 45 \(second)", timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent125)%"),
            .init(db: 110, timeTitle: "\(max) 7 \(minute) 30 \(second)", timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent120)%"),
            .init(db: 107, timeTitle: "\(max) 15 \(minute)", timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent115)%"),
            .init(db: 104, timeTitle: "\(max) 30 \(minute)", timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent110)%"),
            .init(db: 103, timeTitle: max + " 1 " + hour, timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent105)%"),
            .init(db: 100, timeTitle: max + " 2 " + hour, timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent100)%"),
            .init(db: 97, timeTitle:  max + " 4 " + hour,  timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent95)%"),
            .init(db: 94, timeTitle:  max + " 8 " + hour,  timeEvent: timeValueSubject.eraseToAnyPublisher(), procent: "\(precent90)%"),
        ]
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DosimeterCell.id, for: indexPath) as! DosimeterCell
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor(named: "backCell")
        if flag == true {
            cell.configure(item: items[indexPath.row])
            
        } else {
            cell.configure(item: itemNiosh[indexPath.row])
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = collectionView.cellForItem(at: indexPath)
        selectedItem?.layer.borderColor = UIColor.red.cgColor
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
        refreshButton.addTarget(self, action: #selector(refreshButtonTap), for: .touchUpInside)
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
            
            noiseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            noiseButton.widthAnchor.constraint(equalToConstant: 70),
            noiseButton.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: -60)
        ])
    }
}

extension Dosimeter {
    
    @objc func noiseTap() {
        if isTap {
            noiseButton.setTitle("OSHA", for: .normal)
            noiseButton.backgroundColor = UIColor(named: "nosha")
            noiseButton.setTitleColor(UIColor(named: "cellDb"), for: .normal)
            isTap = false
            flag = true
            timeValueSubject.value = [0:0]
            collection?.reloadData()
            recorder.stopMonitoring()
            recorder.stop()
            progress.startAngle = -150
            procentLabel.text = "0"
            decibelLabel.text = "0"
            timeLabel.text = "00:00"
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                self.startRecordingAudio()
            }
        } else {
            noiseButton.setTitle("NIOSH", for: .normal)
            noiseButton.backgroundColor = #colorLiteral(red: 0.137247622, green: 0, blue: 0.956287086, alpha: 1)
            noiseButton.setTitleColor(UIColor.white, for: .normal)
            noiseButton.setTitleColor(UIColor(named: "cellDb"), for: .normal)
            isTap = true
            flag = false
            timeValueSubject.value = [0:0]
            collection?.reloadData()
            recorder.stopMonitoring()
            recorder.stop()
            progress.startAngle = -150
            procentLabel.text = "0"
            decibelLabel.text = "0"
            
            timeLabel.text = "00:00"
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                self.startRecordingAudio()
            }
        }
    }
    
    @objc func refreshButtonTap() {
        
        if Constants.shared.isRecordingAtLaunchEnabled == false{
        }
        recorder.stopMonitoring()
        recorder.stop()
        progress.startAngle = -150
        procentLabel.text = "0"
        decibelLabel.text = "0"
        timeValueSubject.value = [0:0]
        timeLabel.text = "00:00"
        _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
            self.startRecordingAudio()
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
        // FIXME: Unusual
    }
    
    func recorderDidFailToAchievePermission(_ recorder: Recorder) {
        let alertController = UIAlertController(title: NSLocalizedString("Microphone", comment: ""), message: NSLocalizedString("SetMicro", comment: ""), preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        
        let settingButton = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { _
            in
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!,
                options: [:],
                completionHandler: nil)
        }
        
        alertController.addAction(cancelButton)
        alertController.addAction(settingButton)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        
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
            dict[key] = value == nil ? 1 : value! + 0.5
        }
        if (90..<95).contains(decibels) {
            increaseDictValue(&timeDict, key: 90)
        }
        if (95..<100).contains(decibels) {
            increaseDictValue(&timeDict, key: 95)
        }
        if (100..<105).contains(decibels) {
            increaseDictValue(&timeDict, key: 100)
        }
        if (105..<110).contains(decibels) {
            increaseDictValue(&timeDict, key: 105)
        }
        if (110..<115).contains(decibels) {
            increaseDictValue(&timeDict, key: 110)
        }
        if (115..<120).contains(decibels) {
            increaseDictValue(&timeDict, key: 115)
        }
        if (120..<125).contains(decibels) {
            increaseDictValue(&timeDict, key: 120)
        }
        if (125..<130).contains(decibels) {
            increaseDictValue(&timeDict, key: 125)
        }
        if (130..<200).contains(decibels) {
            increaseDictValue(&timeDict, key: 200)
        }
        
        
        if (90..<95).contains(decibels) {
            increaseDictValue(&timeDict, key: 94)
        }
        if (95..<100).contains(decibels) {
            increaseDictValue(&timeDict, key: 97)
        }
        if (100..<105).contains(decibels) {
            increaseDictValue(&timeDict, key: 100)
        }
        if (105..<110).contains(decibels) {
            increaseDictValue(&timeDict, key: 103)
        }
        if (110..<115).contains(decibels) {
            increaseDictValue(&timeDict, key: 106)
        }
        if (115..<120).contains(decibels) {
            increaseDictValue(&timeDict, key: 109)
        }
        if (120..<125).contains(decibels) {
            increaseDictValue(&timeDict, key: 112)
        }
        if (125..<130).contains(decibels) {
            increaseDictValue(&timeDict, key: 115)
        }
        if (130..<200).contains(decibels) {
            increaseDictValue(&timeDict, key: 118)
        }
        
        totalPrecent = (Int(precent90))
        timeValueSubject.send(timeDict)
        timeLabel.text = "\(strMinutes): \(strSeconds)"
        decibelLabel.text = "\(decibels)"
        progress.animate(toAngle: Double(degree * decibels), duration: 0.7, completion: nil)
    }
}

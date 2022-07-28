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
    
    let dosVC = CellDosimetre()
    let remoteConfig = RemoteConfig.remoteConfig()
    private var collection: UICollectionView?
    private var Secondcollection: UICollectionView?
    private var isTap = false
    private var isRecording = true
    private let timeValueSubject = CurrentValueSubject<[Int: Double], Never>([:])
    private let timeValueSubjectSecond = CurrentValueSubject<[Int: Double], Never>([:])
    private let nullValueSubject = [0:0.0]
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
    var flag = true
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
    lazy var noiseButton = Button(style: .noise,"NIOSH")

    lazy var headView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "backCell")
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        return view
    }()
    
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
        secondSetupCollection()
        startRecordingAudio()
        remote()
        
        if defaults.string(forKey: "dosimeter") == nil {
            defaults.set(t, forKey: "dosimeter")
        }
        
        t = Int(defaults.string(forKey: "dosimeter")!)!
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UserDefaults.standard.bool(forKey: "FullAccess") == false {
            t += 1
            defaults.set(t, forKey: "dosimeter")
            
            if Int(defaults.string(forKey: "dosimeter")!)! >= 100 {
                recorder.stopMonitoring()
                recorder.stop()
                procentLabel.text = "0"
                decibelLabel.text = "0"
                timeLabel.text = "00:00"
                
                callPurchase()
            }
        } else {
            print("full access")
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
    
    func secondSetupCollection() {
        let layout = UICollectionViewFlowLayout()
        if UIScreen.main.bounds.height > 700 {
            layout.itemSize = CGSize(width: (view.frame.size.width) - 15, height: 60)
        } else {
            layout.itemSize = CGSize(width: (view.frame.size.width) - 15, height: 46)
        }
        
        layout.minimumLineSpacing = 6
        Secondcollection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        
        guard let collection = Secondcollection else { return }
        
        collection.register(CellDosimetre.self, forCellWithReuseIdentifier: CellDosimetre.id)
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor(named: "backgroundColor")
        collection.indicatorStyle = .black
        view.addSubview(collection)
        if UIScreen.main.bounds.height > 700 {
            NSLayoutConstraint.activate([
                collection.topAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 12),
                collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])

        } else {
            NSLayoutConstraint.activate([
                collection.topAnchor.constraint(equalTo: headView.bottomAnchor, constant: 10),
                collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
            ])

        }
        
        if UIScreen.main.bounds.height > 850 && UIScreen.main.bounds.height < 970 {
            layout.itemSize = CGSize(width: (view.frame.size.width) - 15, height: 67)
        }
    }
    
    func setUpCollection() {
        let layout = UICollectionViewFlowLayout()
        if UIScreen.main.bounds.height > 700 {
            layout.itemSize = CGSize(width: (view.frame.size.width) - 15, height: 60)
        } else {
            layout.itemSize = CGSize(width: (view.frame.size.width) - 15, height: 46)
        }
        
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
        if UIScreen.main.bounds.height > 700 {
            NSLayoutConstraint.activate([
                collection.topAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 12),
                collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                collection.topAnchor.constraint(equalTo: headView.bottomAnchor, constant: 10),
                collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
            ])
        }
        
        if UIScreen.main.bounds.height > 850 && UIScreen.main.bounds.height < 970 {
            layout.itemSize = CGSize(width: (view.frame.size.width) - 15, height: 67)
        }
    }
}

extension Dosimeter: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.Secondcollection {
            return  itemNiosh.count
        }
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
    
    var itemNiosh: [CellDosimetre.ItemOsha] {
        [
            .init(db: 109, timeTitle: "\(max) 1 \(minute) 52 \(second)", timeEvent: timeValueSubjectSecond.eraseToAnyPublisher(), procent: "\(precent130)%"),
            .init(db: 106, timeTitle: "\(max) 3 \(minute) 45 \(second)", timeEvent: timeValueSubjectSecond.eraseToAnyPublisher(), procent: "\(precent125)%"),
            .init(db: 103, timeTitle: "\(max) 7 \(minute) 30 \(second)", timeEvent: timeValueSubjectSecond.eraseToAnyPublisher(), procent: "\(precent120)%"),
            .init(db: 100, timeTitle: "\(max) 15 \(minute)", timeEvent: timeValueSubjectSecond.eraseToAnyPublisher(), procent: "\(precent115)%"),
            .init(db: 97, timeTitle: "\(max) 30 \(minute)", timeEvent: timeValueSubjectSecond.eraseToAnyPublisher(), procent: "\(precent110)%"),
            .init(db: 94, timeTitle: max + " 1 " + hour, timeEvent: timeValueSubjectSecond.eraseToAnyPublisher(), procent: "\(precent105)%"),
            .init(db: 91, timeTitle: max + " 2 " + hour, timeEvent: timeValueSubjectSecond.eraseToAnyPublisher(), procent: "\(precent100)%"),
            .init(db: 88, timeTitle:  max + " 4 " + hour,  timeEvent: timeValueSubjectSecond.eraseToAnyPublisher(), procent: "\(precent95)%"),
            .init(db: 85, timeTitle:  max + " 8 " + hour,  timeEvent: timeValueSubjectSecond.eraseToAnyPublisher(), procent: "\(precent90)%"),
        ]
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.Secondcollection {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: CellDosimetre.id, for: indexPath) as! CellDosimetre
            cell2.layer.cornerRadius = 12
            cell2.layer.masksToBounds = true
            cell2.contentView.backgroundColor = UIColor(named: "backCell")
            cell2.configure(item: itemNiosh[indexPath.row])
    
            return cell2
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DosimeterCell.id, for: indexPath) as! DosimeterCell
            cell.layer.cornerRadius = 12
            cell.layer.masksToBounds = true
            cell.contentView.backgroundColor = UIColor(named: "backCell")
            cell.configure(item: items[indexPath.row])
        
            return cell
        }
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
        timeLabel.layer.opacity = 0.8
        decibelLabel.layer.opacity = 0.8
        noiseButton.setTitle("OSHA", for: .normal)
        noiseButton.backgroundColor = .black
        noiseButton.setTitleColor(UIColor(named: "cellDb"), for: .normal)
        view.backgroundColor = UIColor(named: "backgroundColor")
        noiseButton.addTarget(self, action: #selector(noiseTap), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonTap), for: .touchUpInside)
        view.addSubview(headerLabel)
        view.addSubview(headView)
        view.addSubview(timeLabel)
        view.addSubview(procentLabel)
        view.addSubview(procentImage)
        view.addSubview(decibelLabel)
        view.addSubview(dbImage)
        headView.addSubview(refreshButton)
        headView.addSubview(noiseButton)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            headView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 15),
            headView.heightAnchor.constraint(equalToConstant: 65),
            headView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 5),
            headView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            refreshButton.leadingAnchor.constraint(equalTo: headView.leadingAnchor, constant: 10),
            refreshButton.topAnchor.constraint(equalTo: headView.topAnchor, constant: 7),
            
            noiseButton.trailingAnchor.constraint(equalTo: headView.trailingAnchor, constant: -10),
            noiseButton.topAnchor.constraint(equalTo: headView.topAnchor, constant: 7),
            
            procentLabel.centerXAnchor.constraint(equalTo: headView.centerXAnchor),
            procentLabel.centerYAnchor.constraint(equalTo: headView.centerYAnchor),
            
            timeLabel.trailingAnchor.constraint(equalTo: procentLabel.leadingAnchor, constant: -40),
            timeLabel.topAnchor.constraint(equalTo: procentLabel.topAnchor, constant: 10),
            
            decibelLabel.leadingAnchor.constraint(equalTo: procentLabel.trailingAnchor, constant: 40),
            decibelLabel.topAnchor.constraint(equalTo: procentLabel.topAnchor, constant: 10),
            
            dbImage.leadingAnchor.constraint(equalTo: decibelLabel.trailingAnchor, constant: 5),
            dbImage.topAnchor.constraint(equalTo: decibelLabel.topAnchor, constant: 2),
            
            procentImage.topAnchor.constraint(equalTo: procentLabel.topAnchor),
            procentImage.leadingAnchor.constraint(equalTo: procentLabel.trailingAnchor)
        ])
    }
}

extension Dosimeter {
    
    func fixDosimerer() {
        var nulDict = timeValueSubject.value
//        timeValueSubject.value.removeAll()
//        timeValueSubject.send(nulDict)
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async{ [self] in
            let indexPath8 = IndexPath(item: 8, section: 0)
            let indexPath7 = IndexPath(item: 7, section: 0)
            let indexPath6 = IndexPath(item: 6, section: 0)
            let indexPath5 = IndexPath(item: 5, section: 0)
            let indexPath4 = IndexPath(item: 4, section: 0)
            let indexPath3 = IndexPath(item: 3, section: 0)
            let indexPath2 = IndexPath(item: 2, section: 0)
            let indexPath1 = IndexPath(item: 1, section: 0)
            let indexPath9 = IndexPath(item: 0, section: 0)
            
            DispatchQueue.main.async { [self] in
                collection?.reloadItems(at: [indexPath8])
                collection?.reloadItems(at: [indexPath7])
                collection?.reloadItems(at: [indexPath6])
                collection?.reloadItems(at: [indexPath5])
                collection?.reloadItems(at: [indexPath4])
                collection?.reloadItems(at: [indexPath3])
                collection?.reloadItems(at: [indexPath2])
                collection?.reloadItems(at: [indexPath1])
                collection?.reloadItems(at: [indexPath9])
                collection?.reloadData()
            }
            timeValueSubject.value.removeAll()
            nulDict = timeValueSubject.value
            print(timeValueSubject.value)
            timeValueSubject.send(nulDict)
        }
    }
    
    func fixDosimererSecond() {
        var nulDict = timeValueSubject.value
//        timeValueSubject.value.removeAll()
//        timeValueSubject.send(nulDict)
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async{ [self] in
            let indexPath8 = IndexPath(item: 8, section: 0)
            let indexPath7 = IndexPath(item: 7, section: 0)
            let indexPath6 = IndexPath(item: 6, section: 0)
            let indexPath5 = IndexPath(item: 5, section: 0)
            let indexPath4 = IndexPath(item: 4, section: 0)
            let indexPath3 = IndexPath(item: 3, section: 0)
            let indexPath2 = IndexPath(item: 2, section: 0)
            let indexPath1 = IndexPath(item: 1, section: 0)
            let indexPath9 = IndexPath(item: 0, section: 0)
            
            DispatchQueue.main.async { [self] in
                Secondcollection?.reloadItems(at: [indexPath8])
                Secondcollection?.reloadItems(at: [indexPath7])
                Secondcollection?.reloadItems(at: [indexPath6])
                Secondcollection?.reloadItems(at: [indexPath5])
                Secondcollection?.reloadItems(at: [indexPath4])
                Secondcollection?.reloadItems(at: [indexPath3])
                Secondcollection?.reloadItems(at: [indexPath2])
                Secondcollection?.reloadItems(at: [indexPath1])
                Secondcollection?.reloadItems(at: [indexPath9])
                Secondcollection?.reloadData()
            }
            timeValueSubject.value.removeAll()
            nulDict = timeValueSubject.value
            print(timeValueSubject.value)
            timeValueSubject.send(nulDict)
        }
    }

    
    @objc func noiseTap() {
        if isTap {
            
            noiseButton.setTitle("OSHA", for: .normal)
            noiseButton.backgroundColor = .black
            noiseButton.setTitleColor(UIColor(named: "cellDb"), for: .normal)
            isTap = false
            collection!.isHidden = true
            Secondcollection?.isHidden = false
            recorder.stopMonitoring()
            recorder.stop()
          
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
            Secondcollection?.isHidden = true
            collection?.isHidden = false
            recorder.stopMonitoring()
            recorder.stop()
           
            procentLabel.text = "0"
            decibelLabel.text = "0"
            
            timeLabel.text = "00:00"
            _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                self.startRecordingAudio()
            }
        }
    }
    
    @objc func refreshButtonTap() {
     
        
        if Constants.shared.isRecordingAtLaunchEnabled == false{
        }
        recorder.stopMonitoring()
        recorder.stop()
        fixDosimerer()
        fixDosimererSecond()
        procentLabel.text = "0"
        decibelLabel.text = "0"
        timeLabel.text = "00:00"
        _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            self.startRecordingAudio()
        }
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
        var secondTimeDict = timeValueSubjectSecond.value
        func increaseDictValue(_ dict: inout [Int: Double], key: Int) {
            let value = dict[key]
            dict[key] = value == nil ? 1 : value! + 0.5
        }
        
        func increaseDictValueSecond(_ dict: inout [Int: Double], key: Int) {
            let value = dict[key]
            dict[key] = value == nil ? 1 : value! + 0.5
        }
        
        if (90..<95).contains(decibels) {
            increaseDictValue(&timeDict, key: 90)
            totalPrecent = 1
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
        
        
        if (80..<88).contains(decibels) {
            increaseDictValueSecond(&secondTimeDict, key: 85)
            totalPrecent = 1
        }
        if (88..<91).contains(decibels) {
            increaseDictValueSecond(&secondTimeDict, key: 88)
        }
        if (91..<94).contains(decibels) {
            increaseDictValueSecond(&secondTimeDict, key: 91)
        }
        if (94..<97).contains(decibels) {
            increaseDictValueSecond(&secondTimeDict, key: 94)
        }
        if (97..<100).contains(decibels) {
            increaseDictValueSecond(&secondTimeDict, key: 97)
        }
        if (100..<103).contains(decibels) {
            increaseDictValueSecond(&secondTimeDict, key: 100)
        }
        if (103..<106).contains(decibels) {
            increaseDictValueSecond(&secondTimeDict, key: 103)
        }
        if (106..<109).contains(decibels) {
            increaseDictValueSecond(&secondTimeDict, key: 106)
        }
        if (109..<200).contains(decibels) {
            increaseDictValueSecond(&secondTimeDict, key: 109)
        }
        
        procentLabel.text = "\(totalPrecent)"
        timeValueSubject.send(timeDict)
        timeValueSubjectSecond.send(secondTimeDict)
        timeLabel.text = "\(strMinutes): \(strSeconds)"
        decibelLabel.text = "\(decibels)"
    }
}

//
//  ViewController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 4.05.22.
//

import UIKit
import AVFAudio
import KDCircularProgress
import Charts   
import CoreData
import StoreKit
import FirebaseRemoteConfig
import Photos

class RecordView: UIViewController {
    
    var rateUsInt = 0
    lazy var showVc = "2"
    let remoteConfig = RemoteConfig.remoteConfig()
    let iapManager = InAppManager.share
    var freeSaveRemote = 9
    var freeSave = 3
    var flag = false
    private var isRecording = false
    
    // MARK: Localizable
    var max = NSLocalizedString("Maximum", comment: "")
    var min = NSLocalizedString("Minimum", comment: "")
    var avg = NSLocalizedString("Average", comment: "")
    
    // MARK: Audio recorder & persist
    let recorder = Recorder()
    let persist = Persist()
    var info: RecordInfo!
    var recordings: [Record]?
    
    // MARK: UI elements
    lazy var dbtImage = Label(style: .dbProcentImage, "dB")
    lazy var decibelLabel   = Label(style: .decibelHeading, "0")
    lazy var timeLabel      = Label(style: .timeRecord, "00:00")
    lazy var progress = KDCircularProgress(
        frame: CGRect(x: 0, y: 0, width: view.frame.width / 1.2, height: view.frame.width / 1.2)
    )
    
    lazy var verticalStack = StackView(axis: .vertical)
    lazy var avgBar = AvgMinMaxBar()
    lazy var containerForSmallDisplay: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    
    lazy var chart: BarChartView = {
        let chart = BarChartView()
        chart.noDataText = "Tap the record button to start monitoring."
        
        chart.dragEnabled = true
        chart.pinchZoomEnabled = false
        chart.highlightPerTapEnabled = false
        chart.doubleTapToZoomEnabled = false
        
        chart.legend.enabled = false
        chart.chartDescription.enabled = false
        
        chart.rightAxis.enabled = false
        chart.leftAxis.labelTextColor = .white
        
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.drawLabelsEnabled = false
        
        chart.leftAxis.axisMinimum = 0.0
        chart.leftAxis.axisMaximum = 100.0
        
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        return chart
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        let radius: CGFloat = 20
        let size: CGFloat = 45
        button.layer.cornerRadius = radius
        
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton()
        let radius: CGFloat = 20
        let size: CGFloat = 45
        button.layer.cornerRadius = radius
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        let radius: CGFloat = 130
        let size: CGFloat = 130
        button.layer.cornerRadius = radius
        button.setImage(UIImage(named: "playSVG"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        if UserDefaults.standard.value(forKey: "FullAccess") as! Int != 1 {
            IAPManager.shared.verifyPurcahse(product: .yearTrial)
        } else if UserDefaults.standard.value(forKey: "FullAccess") as! Int != 1 {
            IAPManager.shared.verifyPurcahse(product: .weekTrial)
        } else if UserDefaults.standard.value(forKey: "FullAccess") as! Int != 1 {
            IAPManager.shared.verifyPurcahse(product: .mounthTrial)
        } else if UserDefaults.standard.value(forKey: "FullAccess") as! Int != 1 {
            IAPManager.shared.verifyPurcahse(product: .year)
        } else if UserDefaults.standard.value(forKey: "FullAccess") as! Int != 1 {
            IAPManager.shared.verifyPurcahse(product: .mounth)
        } else if UserDefaults.standard.value(forKey: "FullAccess") as! Int != 1 {
            IAPManager.shared.verifyPurcahse(product: .week)
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        catch {
        }
        remoteConfigSetup()
        recorder.delegate = self
        recorder.avDelegate = self
        
        setupConstraint()
        
        guard let result = persist.fetch() else { return }
        recordings = result
        freeSave = result.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func rateApp() {
        SKStoreReviewController.requestReview()
    }
    
   @objc func appMovedToBackground() {
        isRecording = false
        recorder.stopMonitoring()
        recorder.stop()
        updateChartData()
        progress.animate(toAngle: 0, duration: 0.2, completion: nil)
        decibelLabel.text = "0"
        timeLabel.text = "00:00"
        avgBar.maxDecibelLabel.text = "0"
        avgBar.minDecibelLabel.text = "0"
        avgBar.avgDecibelLabel.text = "0"
       recordButton.setImage(UIImage(named: "playSVG"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if UserDefaults.standard.value(forKey: "theme") as! Int == 0 {
            progress.trackColor = #colorLiteral(red: 0.9514784217, green: 0.960873425, blue: 0.978158772, alpha: 1)
            backView.backgroundColor = #colorLiteral(red: 0.9999999404, green: 0.9999999404, blue: 0.9999999404, alpha: 1)
            view.backgroundColor = #colorLiteral(red: 0.9514784217, green: 0.960873425, blue: 0.978158772, alpha: 1)
            saveButton.setNeedsLayout()
            saveButton.setImage(UIImage(named: "button3-9"), for: .normal)
            resetButton.setImage(UIImage(named: "button3-10"), for: .normal)
            decibelLabel.textColor = .black
            chart.borderColor = .black
            chart.tintColor = .black
            chart.gridBackgroundColor = .black
            chart.noDataTextColor = .black
            avgBar.minLabel.textColor = .black
            avgBar.maxLabel.textColor = .black
            avgBar.avgLabel.textColor = .black
            timeLabel.textColor = .black
            progress.layoutIfNeeded()
            
        }
        
        if UserDefaults.standard.value(forKey: "theme") as! Int == 1 {
            
            progress.trackColor = #colorLiteral(red: 0.07064444572, green: 0.07052957267, blue: 0.07489018887, alpha: 1)
            backView.backgroundColor = #colorLiteral(red: 0.1608400345, green: 0.1607262492, blue: 0.1650899053, alpha: 1)
            view.backgroundColor = #colorLiteral(red: 0.07064444572, green: 0.07052957267, blue: 0.07489018887, alpha: 1)
            saveButton.setNeedsLayout()
            saveButton.setImage(UIImage(named: "saved"), for: .normal)
            resetButton.setImage(UIImage(named: "button3-8"), for: .normal)
            decibelLabel.textColor = .white
            chart.borderColor = .white
            chart.tintColor = .white
            chart.gridBackgroundColor = .white
            chart.noDataTextColor = .white
            avgBar.minLabel.textColor = .white
            avgBar.maxLabel.textColor = .white
            avgBar.avgLabel.textColor = .white
            timeLabel.textColor = .white
            progress.layoutIfNeeded()
        }
    }
    
    func remoteConfigSetup() {
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
        
        remoteConfig.fetchAndActivate { (status, error) in
            
            if error !=  nil {
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["availableFreeSave"].stringValue {
                        self.freeSaveRemote = Int(stringValue) ?? 10
                    }
                }
                
                if status != .error {
                    if let stringValue1 =
                        self.remoteConfig["otherScreenNumber"].stringValue {
                        self.showVc = (stringValue1)
                    }
                }
                
                if status != .error {
                    if let stringValue2 =
                        self.remoteConfig["rateUs"].stringValue {
                        self.rateUsInt = Int(stringValue2) ?? 0
                    }
                }
            }
        }
    }
    
    private func requestPermissions() {
        DispatchQueue.main.async {
            if Constants().isFirstLaunch {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in }
                Constants().isFirstLaunch = false
            }
        }
    }
    
    func rateUs() {
        let vc = RateUsVC()
        //        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: Record/stop button action
extension RecordView {
    
    @objc func startOrStopRecordAction() {
        
        if Constants.shared.isRecordingAtLaunchEnabled {
            if isRecording {
                isRecording = false
                stopRecordingAudio()
                
            } else {
                isRecording = true
                startRecordingAudio()
            }
            
        } else {
            DispatchQueue.main.async {
                let alertController = UIAlertController(
                    title: "Microphone permissions denied",
                    message: NSLocalizedString("SetMicro", comment: ""),
                    preferredStyle: .alert
                )
                
                let cancelButton = UIAlertAction(
                    title: NSLocalizedString("cancel", comment: ""),
                    style: .cancel,
                    handler: nil
                )
                
                let settingsAction = UIAlertAction(
                    title: NSLocalizedString("Settings", comment: ""),
                    style: .default
                ) { _ in
                    UIApplication.shared.open(
                        URL(string: UIApplication.openSettingsURLString)!,
                        options: [:],
                        completionHandler: nil)
                }
                
                alertController.addAction(cancelButton)
                alertController.addAction(settingsAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func saveButtonAction() {
        
        if recorder.min != nil, recorder.avg != nil, recorder.max != nil {
            self.info = RecordInfo(
                id: UUID(),
                name: nil,
                length: timeLabel.text!,
                avg: UInt8(recorder.avg!),
                min: UInt8(recorder.min!),
                max: UInt8(recorder.max!),
                date: Date()
            )
            isRecording = false
            recorder.stopMonitoring()
            recorder.stop()
            updateChartData()
            progress.animate(toAngle: 0, duration: 0.2, completion: nil)
            decibelLabel.text = "0"
            timeLabel.text = "00:00"
            avgBar.maxDecibelLabel.text = "0"
            avgBar.minDecibelLabel.text = "0"
            avgBar.avgDecibelLabel.text = "0"
            recordButton.setImage(UIImage(named: "playSVG"), for: .normal)
            guard let result = persist.fetch() else { return }
            recordings = result
            freeSave = result.count
            
            if let stringValue =
                self.remoteConfig["availableFreeSave"].stringValue {
                self.freeSaveRemote = Int(stringValue) ?? 10
            }
            let t = freeSaveRemote
            
            if UserDefaults.standard.value(forKey: "FullAccess") as! Int == 0 {
                if freeSave >= t{
                    
                    
                    _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [self] Timer in
                        if showVc == "2"{
                            let vcTwo = SubscribeTwoView()
                            vcTwo.modalPresentationStyle = .fullScreen
                            present(vcTwo, animated: true, completion: nil)
                        } else if showVc == "1" {
                            let vcTrial = TrialSubscribe()
                            vcTrial.modalPresentationStyle = .fullScreen
                            present(vcTrial, animated: true, completion: nil)
                        } else if showVc == "3" {
                            let vcTrial = TrialViewController()
                            vcTrial.modalPresentationStyle = .fullScreen
                            present(vcTrial, animated: true, completion: nil)
                        }
                    })
                    
                } else {
                    
                    let alert = UIAlertController(title: NSLocalizedString("save", comment: ""),
                                                  message: nil,
                                                  preferredStyle: .alert)
                    
                    let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""),
                                               style: .cancel,
                                               handler: nil)
                    
                    let save = UIAlertAction(
                        title: NSLocalizedString("save", comment: ""),
                        style: .default,
                        handler: { _ in
                            let name = alert.textFields![0].text
                            
                            if name == "" {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyy-M-d-HH:mm"
                                self.info.name = "Record \(result.count)"
                            } else {
                                self.info.name = name
                            }
                            self.persist.saveAudio(info: self.info)
                        }
                    )
                    
                    alert.addTextField { textField in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyy-M-d-HH:mm"
                        textField.placeholder = "Record \(result.count)"
                        textField.text = "Record \(result.count)"
                    }
                    
                    alert.addAction(cancel)
                    alert.addAction(save)
                    present(alert, animated: true, completion: nil)
                }
                
            } else {
                let alert = UIAlertController(title: NSLocalizedString("save", comment: ""),
                                              message: nil,
                                              preferredStyle: .alert)
                
                let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""),
                                           style: .cancel,
                                           handler: nil)
                
                let save = UIAlertAction(
                    title: NSLocalizedString("save", comment: ""),
                    style: .default,
                    handler: { _ in
                        let name = alert.textFields![0].text
                        
                        if name == "" {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyy-M-d-HH:mm"
                            self.info.name = "Record \(result.count)"
                        } else {
                            self.info.name = name
                        }
                        self.persist.saveAudio(info: self.info)
                    }
                )
                
                alert.addTextField { textField in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyy-M-d-HH:mm"
                    textField.placeholder = "Record \(result.count)"
                    textField.text = "Record \(result.count)"
                    
                }
                
                alert.addAction(cancel)
                alert.addAction(save)
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: Start/stop recording
extension RecordView {
    
    private func startRecordingAudio() {
        recorder.record(self)
        recorder.startMonitoring()
    }
    
    private func stopRecordingAudio() {
        if recorder.min != nil, recorder.avg != nil, recorder.max != nil {
            self.info = RecordInfo(
                id: UUID(),
                name: nil,
                length: timeLabel.text!,
                avg: UInt8(recorder.avg!),
                min: UInt8(recorder.min ?? 50 ),
                max: UInt8(recorder.max!),
                date: Date()
            )
            
            recorder.stopMonitoring()
            recorder.stop()
            updateChartData()
            progress.animate(toAngle: 0, duration: 0.2, completion: nil)
            decibelLabel.text = "0"
            timeLabel.text = "00:00"
            avgBar.maxDecibelLabel.text = "0"
            avgBar.minDecibelLabel.text = "0"
            avgBar.avgDecibelLabel.text = "0"
            
            guard let result = persist.fetch() else { return }
            recordings = result
            freeSave = result.count
            
        }
    }
}

extension RecordView {
    
    @objc func startOrStopRecord() {
        
        guard let result = persist.fetch() else { return }
        recordings = result
        freeSave = result.count
        if UserDefaults.standard.value(forKey: "FullAccess") as! Int == 0 {
            if freeSave >= freeSaveRemote{
                _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [self] Timer in
                    if showVc == "2"{
                        let vcTwo = SubscribeTwoView()
                        vcTwo.modalPresentationStyle = .fullScreen
                        present(vcTwo, animated: true, completion: nil)
                    } else if showVc == "1" {
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
            
            if isRecording {
                recordButton.setImage(UIImage(named: "playSVG"), for: .normal)
                isRecording = false
                stopRecordingAudio()
            } else {
                isRecording = true
                startRecordingAudio()
                recordButton.setImage(UIImage(named: "stop"), for: .normal)
            }
        } else {
            
            if isRecording {
                recordButton.setImage(UIImage(named: "playSVG"), for: .normal)
                isRecording = false
                stopRecordingAudio()
            } else {
                isRecording = true
                startRecordingAudio()
                recordButton.setImage(UIImage(named: "stop"), for: .normal)
            }
        }
    }
    
    @objc func resetButtonAction(){
        
        if isRecording{
            recorder.stopMonitoring()
            recorder.stop()
            updateChartData()
            progress.animate(toAngle: 0, duration: 0.2, completion: nil)
            decibelLabel.text = "0"
            timeLabel.text = "00:00"
            avgBar.maxDecibelLabel.text = "0"
            avgBar.minDecibelLabel.text = "0"
            avgBar.avgDecibelLabel.text = "0"
            recordButton.setImage(UIImage(named: "playSVG"), for: .normal)
            startRecordingAudio()
            recordButton.setImage(UIImage(named: "stop"), for: .normal)
        } else {
        }
    }
}

// MARK: Setup view
extension RecordView {
    
    func setupConstraint() {
        let flag = false
        if let stringValue2 =
            self.remoteConfig["rateUs"].stringValue {
            self.rateUsInt = Int(stringValue2) ?? 0
        }
        
        if rateUsInt == 0 {
            DispatchQueue.main.async { [self] in
                if Int(UserDefaults.standard.string(forKey: "enterCounter")!)! == 2 {
                    let count = 3
                    UserDefaults.standard.set(count, forKey: "enterCounter")
                    rateApp()
                }
            }
        } else if rateUsInt == 1 {
            
            if Int(UserDefaults.standard.string(forKey: "enterCounter")!)! == 2 {
                let count = 3
                UserDefaults.standard.set(count, forKey: "enterCounter")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    if flag == false {
                        flag == true
                        self.rateUs()
                    }
                }
            }
        }
        
        setupCircleView()
        view.addSubview(dbtImage)
        view.addSubview(chart)
        view.addSubview(progress)
        view.addSubview(avgBar)
        view.addSubview(verticalStack)
        view.addSubview(backView)
        backView.addSubview(recordButton)
        backView.addSubview(resetButton)
        backView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        progress.addSubview(lineView)
        verticalStack.addArrangedSubview(decibelLabel)
        verticalStack.addArrangedSubview(timeLabel)
        
        resetButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(startOrStopRecord), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            verticalStack.centerYAnchor.constraint(equalTo: progress.centerYAnchor, constant: -30),
            verticalStack.centerXAnchor.constraint(equalTo: progress.centerXAnchor),
            
            chart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            chart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            chart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            chart.heightAnchor.constraint(equalToConstant: 150),
            
            backView.heightAnchor.constraint(equalToConstant: 100),
            backView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            backView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            avgBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avgBar.bottomAnchor.constraint(equalTo: backView.topAnchor, constant: -25),
            
            dbtImage.bottomAnchor.constraint(equalTo: decibelLabel.topAnchor, constant: 10),
            dbtImage.leadingAnchor.constraint(equalTo: decibelLabel.trailingAnchor),
            
            recordButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            
            resetButton.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            resetButton.leadingAnchor.constraint(equalTo: backView.safeAreaLayoutGuide.leadingAnchor, constant: 73.5),
            resetButton.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: -24),
            
            saveButton.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: backView.safeAreaLayoutGuide.trailingAnchor, constant: -73.5),
            saveButton.leadingAnchor.constraint(equalTo: recordButton.trailingAnchor, constant: 24),
            
            lineView.centerYAnchor.constraint(equalTo: progress.centerYAnchor, constant: 5),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

extension RecordView {
    
    func checkPhotoLibraryPermission() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            photoPerm()
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                } else {
                    self.photoPerm()
                }
            })
        } else {
            DispatchQueue.main.async {
                self.photoPerm()
            }
        }
    }
    
    func photoPerm() {
        let alertController = UIAlertController(
            title: NSLocalizedString ("photo", comment: ""),
            message: NSLocalizedString("SetPhoto", comment: ""),
            preferredStyle: .alert
        )
        
        let cancelButton = UIAlertAction(
            title: NSLocalizedString("cancel", comment: ""),
            style: .cancel,
            handler: nil
        )
        
        let settingsAction = UIAlertAction(
            title: NSLocalizedString("Settings", comment: ""),
            style: .default
        ) { _ in
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!,
                options: [:],
                completionHandler: nil)
        }
        
        alertController.addAction(cancelButton)
        alertController.addAction(settingsAction)
    }
    
    // MARK: Setup circle view
    private func setupCircleView() {
        progress.startAngle = -180
        progress.angle = 0
        progress.progressThickness = 0.7
        progress.trackThickness = 0.7
        progress.clockwise = true
        progress.roundedCorners = false
        progress.glowMode = .constant
        progress.trackColor = #colorLiteral(red: 0.07064444572, green: 0.07052957267, blue: 0.07489018887, alpha: 1)
        progress.set(colors:UIColor.purple, UIColor.blue, UIColor.blue, UIColor.purple)
        progress.center = CGPoint(x: view.center.x, y: view.center.y / 1.0 )
    }
    
    func updateChartData() {
        var entries = [BarChartDataEntry]()
        for i in 0..<45 {
            entries.append(BarChartDataEntry(x: Double(i), y: Double(recorder.decibels[i])))
        }
        let set = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: set)
        chart.data = data
        
        set.colors = [.systemPurple]
        chart.barData?.setDrawValues(false)
    }
}

// MARK: Recorder delegate
extension RecordView: AVAudioRecorderDelegate, RecorderDelegate {
    
    func recorder(_ recorder: Recorder, didFinishRecording info: RecordInfo) {
        // FIXME: Unusual
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // FIXME: Unusual
    }
    
    func recorderDidFailToAchievePermission(_ recorder: Recorder) {
        let alertController = UIAlertController(
            title: NSLocalizedString("Microphone", comment: ""),
            message: NSLocalizedString("SetMicro", comment: ""),
            preferredStyle: .alert
        )
        
        let cancelButton = UIAlertAction(
            title: NSLocalizedString("cancel", comment: ""),
            style: .cancel,
            handler: nil
        )
        
        let settingsAction = UIAlertAction(
            title: NSLocalizedString("Settings", comment: ""),
            style: .default
        ) { _ in
            UIApplication.shared.open(
                URL(string: UIApplication.openSettingsURLString)!,
                options: [:],
                completionHandler: nil)
        }
        
        alertController.addAction(cancelButton)
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func recorder(_ recorder: Recorder, didCaptureDecibels decibels: Int) {
        let degree = 180 / 110
        
        guard let min = recorder.min else { return }
        guard let max = recorder.max else { return }
        guard let avg = recorder.avg else { return }
        
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
        
        timeLabel.text              = "\(strMinutes):\(strSeconds)"
        decibelLabel.text           = "\(decibels)"
        avgBar.avgDecibelLabel.text = "\(avg)"
        avgBar.minDecibelLabel.text = "\(min)"
        avgBar.maxDecibelLabel.text = "\(max)"
        progress.animate(toAngle: Double(degree * decibels), duration: 0.4, completion: nil)
        updateChartData()
    }
}

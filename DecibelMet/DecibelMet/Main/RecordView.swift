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

class RecordView: UIViewController {

    private var isRecording = false
    
    // MARK: Audio recorder & persist
    let recorder = Recorder()
    let persist = Persist()
    var info: RecordInfo!
    
    // MARK: UI elements
    lazy var decibelLabel   = Label(style: .decibelHeading, "0")
    lazy var timeLabel      = Label(style: .time, "00:00")
//    lazy var timeTitleLabel = Label(style: .timeTitle, "TIME")
    
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
        chart.noDataTextColor = .secondarySystemBackground
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
        view.backgroundColor = #colorLiteral(red: 0.1176470444, green: 0.1176470444, blue: 0.1176470444, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 18
        return view
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        let radius: CGFloat = 20
        let size: CGFloat = 45
        button.layer.cornerRadius = radius
        button.setImage(UIImage(named: "button3-2"), for: .normal)
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
        button.setImage(UIImage(named: "button3-3"), for: .normal)
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
        button.setImage(UIImage(named: "png"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder.delegate = self
        recorder.avDelegate = self
        
//        setupView()
        tabBarController?.tabBar.isHidden = false
        setupConstraint()
        
        if Constants().isRecordingAtLaunchEnabled {
            isRecording = true
            startRecordingAudio()
        }
        
        requestPermissions()
    }
    
    private func requestPermissions() {
        if !Constants().isFirstLaunch {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in }
            Constants().isFirstLaunch = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        recorder.stopMonitoring()
    }
    
   
}

// MARK: Record/stop button action
extension RecordView {
    
    @objc func startOrStopRecordAction() {
        if isRecording {
            isRecording = false
            stopRecordingAudio()
//            recordButton.setImage(UIImage(named: "Microphone"), for: .normal)
        } else {
            isRecording = true
            startRecordingAudio()
//            recordButton.setImage(UIImage(named: "Stop"), for: .normal)
        }
    }
    
    @objc func resetAction() {
        print(1)
    }
    
    @objc func playOrPauseAction() {
        print (2)
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
                min: UInt8(recorder.min!),
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
            
            let alert = UIAlertController(
                title: "Recording name",
                message: nil, preferredStyle: .alert
            )
            
            let cancel = UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            )
            
            let save = UIAlertAction(
                title: "Save",
                style: .default,
                handler: { _ in
                    let name = alert.textFields![0].text
                    
                    if name == "" {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyy-M-d-HH:mm"
                        self.info.name = dateFormatter.string(from: self.info.date as Date)
                    } else {
                        self.info.name = name
                    }
                    self.persist.saveAudio(info: self.info)
                }
            )
            
            alert.addTextField { textField in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyy-M-d-HH:mm"
                textField.placeholder = "\(dateFormatter.string(from: self.info.date as Date))"
            }
            
            alert.addAction(cancel)
            alert.addAction(save)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

extension RecordView {
    
    @objc func startOrStopRecord() {
        if isRecording {
            isRecording = false
            stopRecordingAudio()
        } else {
            isRecording = true
            startRecordingAudio()
        }
    }
}

// MARK: Setup view
extension RecordView {
    func setupConstraint() {
        
        setupCircleView()
        view.addSubview(chart)
        view.addSubview(progress)
        view.addSubview(progress)
        view.addSubview(avgBar)
        view.addSubview(verticalStack)
        view.addSubview(backView)
        backView.addSubview(recordButton)
        backView.addSubview(resetButton)
        backView.addSubview(saveButton)
        verticalStack.addArrangedSubview(decibelLabel)
        verticalStack.addArrangedSubview(timeLabel)
        
        recordButton.addTarget(self, action: #selector(startOrStopRecord), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            verticalStack.centerYAnchor.constraint(equalTo: progress.centerYAnchor, constant: -30),
            verticalStack.centerXAnchor.constraint(equalTo: progress.centerXAnchor),
            
            chart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            chart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            chart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            chart.heightAnchor.constraint(equalToConstant: 200),
            
            avgBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avgBar.centerYAnchor.constraint(equalTo: progress.centerYAnchor, constant: 60),
            
            backView.topAnchor.constraint(equalTo: avgBar.topAnchor, constant: 90),
            backView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            backView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            
            recordButton.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            
            resetButton.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            resetButton.leadingAnchor.constraint(equalTo: backView.safeAreaLayoutGuide.leadingAnchor, constant: 73.5),
            resetButton.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: -24),

            saveButton.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: backView.safeAreaLayoutGuide.trailingAnchor, constant: -73.5),
            saveButton.leadingAnchor.constraint(equalTo: recordButton.trailingAnchor, constant: 24),
        ])
    }
}

extension RecordView {
    
    private func setupView() {
        view.backgroundColor = .black

        setupCircleView()
        view.addSubview(progress)
        view.addSubview(verticalStack)
        verticalStack.addArrangedSubview(decibelLabel)
        verticalStack.addArrangedSubview(timeLabel)
//        verticalStack.addArrangedSubview(timeTitleLabel)

        if Constants().isBig {
            view.addSubview(avgBar)
            view.addSubview(chart)
        } else {
            view.addSubview(containerForSmallDisplay)
            containerForSmallDisplay.addSubview(avgBar)
        }

        view.addSubview(recordButton)
        
        view.addSubview(resetButton)

        verticalStack.setCustomSpacing(10, after: decibelLabel)

        let constraints: [NSLayoutConstraint]

        let constraintsForBigDisplay = [
            verticalStack.centerYAnchor.constraint(equalTo: progress.centerYAnchor),
            verticalStack.centerXAnchor.constraint(equalTo: progress.centerXAnchor),

            avgBar.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 5),
            avgBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            chart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            chart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            chart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            chart.heightAnchor.constraint(equalToConstant: 10),

            progress.topAnchor.constraint(equalTo: chart.bottomAnchor, constant: 40),
            progress.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progress.heightAnchor.constraint(equalToConstant: 150),

            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            resetButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
        ]

        let constraintsForSmallDisplay = [
            verticalStack.centerYAnchor.constraint(equalTo: progress.centerYAnchor),
            verticalStack.centerXAnchor.constraint(equalTo: progress.centerXAnchor),

            containerForSmallDisplay.topAnchor.constraint(equalTo: progress.bottomAnchor),
            containerForSmallDisplay.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerForSmallDisplay.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerForSmallDisplay.bottomAnchor.constraint(equalTo: recordButton.topAnchor),

            avgBar.centerXAnchor.constraint(equalTo: containerForSmallDisplay.centerXAnchor),
            avgBar.centerYAnchor.constraint(equalTo: containerForSmallDisplay.centerYAnchor, constant: -20),

            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]

        if Constants().isBig {
            constraints = constraintsForBigDisplay
        } else {
            constraints = constraintsForSmallDisplay
        }

        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Setup circle view
    private func setupCircleView() {
        progress.startAngle = -180
        progress.angle = 0
        progress.progressThickness = 0.5
        progress.trackThickness = 0.7
        progress.clockwise = true
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.trackColor = .black

        progress.set(colors:UIColor.purple, UIColor.blue, UIColor.blue, UIColor.purple)
        progress.center = CGPoint(x: view.center.x, y: view.center.y / 0.9 )
    }
    
    func updateChartData() {
        var entries = [BarChartDataEntry]()
        for i in 5..<45 {
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
        print("Record finished")
        // FIXME: Unusual
    }
    
    func recorderDidFailToAchievePermission(_ recorder: Recorder) {
        let alertController = UIAlertController(
            title: "Microphone permissions denied",
            message: "Microphone permissions have been denied for this app. You can change this by going to Settings",
            preferredStyle: .alert
        )

        let cancelButton = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )

        let settingsAction = UIAlertAction(
            title: "Settings",
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

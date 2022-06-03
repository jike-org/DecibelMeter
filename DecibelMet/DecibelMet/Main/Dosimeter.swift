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

 class Dosimeter: UIViewController {
     
     private var isRecording = false
     
    //MARK: - Audio recorder / resist
     let recorder = Recorder()
     let persist = Persist()
     var info: RecordInfo!
     
    //MARK: - UI elements
    lazy var headerLabel = Label(style: .heading, "DOSIMETER")
    lazy var timeLabel = Label(style: .time, "00:00")
    lazy var procentLabel = Label(style: .heading, "72.5")
    lazy var procentImage = Label(style: .heading, "%")
    lazy var decibelLabel = Label(style: .heading, "132")
    lazy var dbImage = Label(style: .heading, "dB")
    lazy var refreshButton = Button(style: .close, nil)
    lazy var noiseButton = Button(style: .close, "NOISE")
    lazy var testButton = Button(style: .playOrPause, "play")
    lazy var progress = KDCircularProgress(
        frame: CGRect(x: 0, y: 0, width: view.frame.width / 1.2, height: view.frame.width / 1.2)
    )
    
    
     override func viewDidLoad() {
         super.viewDidLoad()
         recorder.delegate = self
         recorder.avDelegate = self
         
 //        setupView()
         tabBarController?.tabBar.isHidden = false
         setup()
         
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
         
//         recorder.stopMonitoring()
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
        
        
        
        setupCircleView()
        view.addSubview(progress)
        view.addSubview(testButton)
        
        testButton.addTarget(self, action: #selector(test), for: .touchUpInside)
        testButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            testButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            testButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            testButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    @objc func test() {
        if isRecording {
            isRecording = false
//            recordButton.setImage(UIImage(named: "Microphone"), for: .normal)
        } else {
            isRecording = true
            startRecordingAudio()
//            recordButton.setImage(UIImage(named: "Stop"), for: .normal)
        }
    }
}
// MARK: Setup circle view
extension Dosimeter {
 
    private func setupCircleView() {
        progress.startAngle = -270
        progress.progressThickness = 0.6
        progress.trackThickness = 0.7
        progress.clockwise = true
        progress.roundedCorners = true
        progress.glowMode = .noGlow
        progress.trackColor = .black
        progress.set(colors:UIColor.green, UIColor.yellow, UIColor.orange, UIColor.red)
        progress.center = CGPoint(x: view.center.x, y: view.center.y / 1.9)
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
        
        headerLabel.text = "\(strMinutes): \(strSeconds)"
        decibelLabel.text = "\(decibels)"
        progress.animate(toAngle: Double(degree * decibels), duration: 0.4, completion: nil)
    }
}

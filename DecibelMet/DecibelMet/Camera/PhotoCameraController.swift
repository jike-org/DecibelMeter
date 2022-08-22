//
//  PhotoCameraController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 18.07.22.
//

import AVFoundation
import Foundation
import UIKit
import AVFAudio
import CoreLocation
import FirebaseRemoteConfig
import Photos

class PhotoCameraController: UIViewController, UINavigationControllerDelegate  {
    
    let remoteConfig = RemoteConfig.remoteConfig()
    lazy var freeCamera: Int = 3
    lazy var showVc = "1"
    var counterCamera = -1
    var defaults = UserDefaults.standard
    
    var locationManager: CLLocationManager!
    let lnoise = NSLocalizedString("noiseData", comment: "")
    let lmax = NSLocalizedString("Maximum", comment: "")
    let lAvg = NSLocalizedString("Average", comment: "")
    let lMin = NSLocalizedString("Minimum", comment: "")
    let lLocation = NSLocalizedString("Location", comment: "")
    let lDate = NSLocalizedString("Date", comment: "")
    
    let recorder = Recorder()
    lazy var labelMax = Label(style: .camera, lmax)
    lazy var labelMin = Label(style: .camera, lMin)
    lazy var labelAvg = Label(style: .camera, lAvg)
    lazy var noiseLevel = Label(style: .camera, lnoise)
    lazy var location = Label(style: .camera, lLocation)
    lazy var date = Label(style: .camera, lDate)
    
    
    var imageTake: UIImageView!
    var imagePicker: UIImagePickerController!
    let takePhotoButton = Button(style: .restoreButton, NSLocalizedString("CameraSet", comment: ""))
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remote()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        recorder.delegate = self
        recorder.avDelegate = self
        startRecordingAudio()
//        selectImageFrom(.camera)
        view.addSubview(takePhotoButton)
        takePhotoButton.backgroundColor = #colorLiteral(red: 0.1176470444, green: 0.1176470444, blue: 0.1176470444, alpha: 1)
        takePhotoButton.tintColor = .white
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
     
        takePhotoButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            takePhotoButton.heightAnchor.constraint(equalToConstant: 100),
            takePhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            takePhotoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            takePhotoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40)
            
        ])
        takePhoto()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.checkPhotoLibraryPermission()

    }
    
    //MARK: - Take image
    @objc func takePhoto() {
       
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
          
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    selectImageFrom(.photoLibrary)
                    return
                }
            DispatchQueue.main.async { [self] in
                selectImageFrom(.camera)
            }
             
            
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [self] (granted: Bool) -> Void in
               if granted == true {
                   // User granted
                       guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                           selectImageFrom(.photoLibrary)
                           return
                       }
                   DispatchQueue.main.async { [self] in
                       selectImageFrom(.camera)
                   }
               } else {
                 
                   DispatchQueue.main.async {
                       self.checkPermision()
                   }
               }
           })
        }
    
    locPermisison()
       
    }
    
    func guideForCameraOverlay1() -> UIView {
        let guide = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        guide.backgroundColor = .clear
        guide.isUserInteractionEnabled = false
        guide.isUserInteractionEnabled = false
        guide.addSubview(labelMax)
        guide.addSubview(labelMin)
        guide.addSubview(labelAvg)
        guide.addSubview(location)
        guide.addSubview(date)
        guide.addSubview(noiseLevel)
        labelAvg.textAlignment = .left
        labelMax.textAlignment = .left
        labelMin.textAlignment = .left
        noiseLevel.textAlignment = .left
        date.textAlignment = .right
        location.textAlignment = .right
        
        NSLayoutConstraint.activate([
            noiseLevel.topAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.topAnchor, constant: 100),
            noiseLevel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            noiseLevel.widthAnchor.constraint(equalToConstant: 150),
            noiseLevel.heightAnchor.constraint(equalToConstant: 40),
            
            labelAvg.topAnchor.constraint(equalTo: noiseLevel.bottomAnchor, constant: -15),
            labelAvg.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            labelAvg.widthAnchor.constraint(equalToConstant: 150),
            labelAvg.heightAnchor.constraint(equalToConstant: 40),
            
            labelMin.topAnchor.constraint(equalTo: labelAvg.bottomAnchor, constant: -15),
            labelMin.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            labelMin.widthAnchor.constraint(equalToConstant: 150),
            labelMin.heightAnchor.constraint(equalToConstant: 40),
            
            labelMax.topAnchor.constraint(equalTo: labelMin.bottomAnchor, constant: -15),
            labelMax.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 17),
            labelMax.widthAnchor.constraint(equalToConstant: 150),
            labelMax.heightAnchor.constraint(equalToConstant: 40),
            
            location.bottomAnchor.constraint(equalTo: guide.safeAreaLayoutGuide.bottomAnchor, constant: -250),
            location.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -5),
            location.widthAnchor.constraint(equalToConstant: 200),
            location.heightAnchor.constraint(equalToConstant: 40),
            
            date.topAnchor.constraint(equalTo: location.bottomAnchor),
            date.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -5),
            date.widthAnchor.constraint(equalToConstant: 150),
            date.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        return guide
    }
    
    func guideForCameraOverlay() -> UIView {
        let guide = UIView(frame: CGRect(x: 300, y: 300, width: 200, height: 150))
        guide.backgroundColor = .clear
        guide.isUserInteractionEnabled = false
        
        return guide
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        counterCamera += 1
        imagePicker.cameraOverlayView = guideForCameraOverlay1()
        present(imagePicker, animated: true, completion: nil)
     
    }
    
    @objc func save() {
        guard let selectedImage = imageTake.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
extension PhotoCameraController {
    func checkPermision() {
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
        } else {
            Constants.shared.cameraPermission = true
            cameraAlert()
//                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
//               if granted == true {
//                   print("grant")
//               } else {
//                   print("NONgrant")
//               }
//           })
        }
    }
    
    func cameraAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString("Camera", comment: ""),
            message: NSLocalizedString("CameraSet", comment: ""),
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
    
    func locPermisison() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                //.notDetermined, .restricted,
                case  .denied:
                let alertController = UIAlertController(
                    title: NSLocalizedString("Location", comment: ""),
                    message: NSLocalizedString("setLocation", comment: ""),
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
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
            case .notDetermined:
       break
            case .restricted:
                break
            @unknown default:
                    break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    

    
    func checkPhotoLibraryPermission() {
        if #available(iOS 14, *) {
            switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
            case .notDetermined:
                self.photoPerm()
            case .restricted, .denied:
                self.photoPerm()
            case .authorized: break
                // we have full access
                
                // new option:
            case .limited:
                self.photoPerm()
            @unknown default:
                break
            }
        } else {
            // Fallback on earlier versions
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
}

extension PhotoCameraController {
    func remote() {
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        remoteConfig.configSettings = setting
        remoteConfig.fetchAndActivate { (status, error) in
            if error !=  nil {
                print(error?.localizedDescription as Any)
            } else {
                if status != .error {
                    if let stringValue =
                        self.remoteConfig["availableFreePhoto"].stringValue {
                        self.freeCamera = Int(stringValue)!
                        print(self.freeCamera)
                    }
                    if let stringValue1 =
                        self.remoteConfig["otherScreenNumber"].stringValue {
                        self.showVc = (stringValue1)
                    }
                }
            }
        }
    }
    
    
    
    func purchasesCall() {
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [self] Timer in
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
    
}

extension PhotoCameraController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true)

        guard info[.originalImage] is UIImage else {
          print("Image not found!")
            return
        }
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        photoPerm()
        guard let layer = keyWindow?.layer else { return }
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
       
    }
}

extension PhotoCameraController {
    private func startRecordingAudio() {
        recorder.record(self)
        recorder.startMonitoring()
        counterCamera += 1
    }
}

extension PhotoCameraController: AVAudioRecorderDelegate, RecorderDelegate {
    
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
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func recorder(_ recorder: Recorder, didCaptureDecibels decibels: Int) {
        
        guard let min = recorder.min else { return }
        guard let max = recorder.max else { return }
        guard let avg = recorder.avg else { return }
        
        let db = "dB"
        
        labelMax.text = " \(lmax): \(max) \(db)"
        labelAvg.text = "\(lAvg): \(avg) \(db)"
        labelMin.text = "\(lMin): \(min) \(db)"
        
        let time = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let formatteddate = dateFormatter.string(from: time as Date)
        date.text = String(formatteddate)
    }
}

extension PhotoCameraController: CLLocationManagerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) {[self] (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
                location.text = "error"
            }
            
            if placemarks != nil {
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks![0]
                    self.location.text = "\(placemark.locality!), \(placemark.country!)"
                    return
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

//
//  PhotoCameraController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 18.07.22.
//

import Foundation
import UIKit
import AVFAudio
import CoreLocation

class PhotoCameraController: UIViewController, UINavigationControllerDelegate  {
    
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
    let takePhotoButton = Button(style: .restoreButton, "TAKEPHOTO")
    let savePhotoButton = Button(style: .restoreButton, "TAKEPHOTO")
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        selectImageFrom(.camera)
        view.addSubview(takePhotoButton)
        takePhotoButton.backgroundColor = .cyan
        //        takePhotoButton.layer.zPosition = 1
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        takePhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(savePhotoButton)
        takePhotoButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        savePhotoButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        
    }
    
    //MARK: - Take image
    @objc func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
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
        date.textAlignment = .right
        location.textAlignment = .right
        //        guide.addSubview(labelMin)
        //        guide.addSubview(labelAvg)
        //        guide.addSubview(noiseLevel)
        
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
            labelMax.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
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
        imagePicker.cameraOverlayView = guideForCameraOverlay1()
        //        imagePicker.cameraOverlayView = guideForCameraOverlay()
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func save() {
        guard let selectedImage = imageTake.image else {
            print("Image not found!")
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

extension PhotoCameraController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        guard let layer = keyWindow?.layer else { return }
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
        let vc = TabBar()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension PhotoCameraController {
    
    private func startRecordingAudio() {
        recorder.record(self)
        recorder.startMonitoring()
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
        
        labelMax.text = " \(lmax) \(max)"
        labelAvg.text = "\(lAvg) \(avg)"
        labelMin.text = "\(lMin) \(min)"
        
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

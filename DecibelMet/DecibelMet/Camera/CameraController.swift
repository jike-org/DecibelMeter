//
//  CameraController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 5.05.22.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
class CameraController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var controller = UIImagePickerController()
    let videoFileName = "/video.mp4"
    lazy var cameraViewController = Label(style: .heading, "Camera")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        tabBarController?.tabBar.isHidden = true
        setup()
        openVideoCamera()
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill"), for: .normal)
        let radius: CGFloat = 20
        let size: CGFloat = 45
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = radius
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            // Save video to the main photo album
            let selectorToCall = #selector(CameraController.videoSaved(_:didFinishSavingWithError:context:))
            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = try? Data(contentsOf: selectedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
            try! videoData?.write(to: dataPath, options: [])
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
            })
        }
    }
}

extension CameraController {
    
    @objc func backButtonCamera() {
        let vc = TabBar()
        tabBarController?.tabBar.isHidden = false
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func openVideoCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            // 2 Present UIImagePickerController to take video
            controller.sourceType = .camera
            controller.mediaTypes = [kUTTypeMovie as String]
            controller.delegate = self
            
            present(controller, animated: true, completion: nil)
        }
        else {
            print("Camera is not available")
        }
    }
 
}

extension CameraController {
    
    func setup() {
        view.addSubview(backButton)
        view.addSubview(cameraViewController)
        backButton.addTarget(self, action: #selector(backButtonCamera), for: .touchUpInside)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cameraViewController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraViewController.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
}

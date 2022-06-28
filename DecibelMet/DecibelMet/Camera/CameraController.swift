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

    var flag = true
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        openVideoCamera()
    }

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
            controller.cameraOverlayView = guideForCameraOverlay1()
            present(controller, animated: true, completion: nil)
            controller.dismiss(animated: true) {
                let pr = RecordView()
                self.present(pr, animated: true, completion: nil)
            }


        }
        else {
            print("Camera is not available")
        }
    }
    func guideForCameraOverlay1() -> UIView {
        let guide = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        guide.backgroundColor = .green
        guide.layer.borderWidth = 4
        guide.layer.borderColor = UIColor.red.cgColor
        guide.isUserInteractionEnabled = false
        return guide
    }
}


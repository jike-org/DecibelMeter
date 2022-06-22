//
//  PickerViewController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 20.06.22.
//

import UIKit
import MobileCoreServices
import AVKit

class PickerViewController: UIViewController {
  private let editor = VideoEditor()
    
  override func viewDidLoad() {
    super.viewDidLoad()
      pickVideo(from: .camera)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
   func pickVideo(from sourceType: UIImagePickerController.SourceType) {
    let pickerController = UIImagePickerController()
    pickerController.sourceType = sourceType
    pickerController.mediaTypes = [kUTTypeMovie as String]
    pickerController.videoQuality = .typeIFrame1280x720
    if sourceType == .camera {
      pickerController.cameraDevice = .front
    }
      pickerController.cameraOverlayView = guideForCameraOverlay1()
    present(pickerController, animated: true)
  }
  
  private func showVideo(at url: URL) {
    let player = AVPlayer(url: url)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    present(playerViewController, animated: true) {
      player.play()
    }
  }
    
    func guideForCameraOverlay() -> UIView {
        let guide = UIView(frame: UIScreen.main.fullScreenSquare())
        guide.backgroundColor = UIColor.clear
        guide.layer.borderWidth = 4
        guide.layer.borderColor = UIColor.red.cgColor
        guide.isUserInteractionEnabled = false
        return guide
    }
    
    func guideForCameraOverlay1() -> UIView {
        let guide = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 100))
        guide.backgroundColor = .green
        guide.layer.borderWidth = 4
        guide.layer.borderColor = UIColor.red.cgColor
        guide.isUserInteractionEnabled = false
        return guide
    }
  
  private var pickedURL: URL?
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard
      let url = pickedURL,
      let destination = segue.destination as? PlayerViewController
      else {
        return
    }
    
    destination.videoURL = url
  }
}

extension PickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard
      let url = info[.mediaURL] as? URL
      else {
        print("Cannot get video URL")
        return
    }
    
    dismiss(animated: true) {
      self.editor.makeBirthdayCard(fromVideoAt: url, forName: "name") { exportedURL in
        guard let exportedURL = exportedURL else {
          return
        }
        self.pickedURL = exportedURL
        self.performSegue(withIdentifier: "showVideo", sender: nil)
      }
    }
  }
}

extension UIScreen {
    func fullScreenSquare() -> CGRect {
        var hw:CGFloat = 0
        var isLandscape = false
        if UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height {
        hw = UIScreen.main.bounds.size.width
    }
    else {
        isLandscape = true
        hw = UIScreen.main.bounds.size.height
    }

    var x:CGFloat = 0
    var y:CGFloat = 0
    if isLandscape {
        x = (UIScreen.main.bounds.size.width / 2) - (hw / 2)
    }
    else {
        y = (UIScreen.main.bounds.size.height / 2) - (hw / 2)
    }
        return CGRect(x: x, y: y, width: hw, height: hw)
    }
}

//import UIKit
//import MobileCoreServices
//import AVKit
//
//class PickerViewController: UIViewController {
//  private let editor = VideoEditor()
//  
////  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//  @IBOutlet weak var recordButon: UIButton!
////  @IBOutlet weak var pickButton: UIButton!
////  @IBOutlet weak var imageView: UIImageView!
//  @IBOutlet weak var naeTextField: UITextField!
//    
//    let recordButton = Button(style: ._continue, "")
//    
//    var nameTextField: UITextField = {
//        let tf = UITextField()
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.backgroundColor = .white
//        return tf
//    }()
//  
//  @objc func recordButtonTapped(_ sender: Any) {
//    pickVideo(from: .camera)
//  }
//  
//  @IBAction func pickVideoButtonTapped(_ sender: Any) {
//    pickVideo(from: .savedPhotosAlbum)
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//      view.addSubview(recordButton)
//      view.addSubview(nameTextField)
//    nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
//    nameTextField.delegate = self
//    nameTextField.returnKeyType = .done
//      
//      nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//      nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//      nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//      recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
//      recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60).isActive = true
//      recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
//    
//    recordButton.isEnabled = false
////    pickButton.isEnabled = false
//  }
//  
//  @objc private func nameTextFieldChanged(_ textField: UITextField) {
//    let text = textField.text ?? ""
//    if text.isEmpty {
//      recordButton.isEnabled = false
////      pickButton.isEnabled = false
//    } else {
//      recordButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
////      pickButton.isEnabled = true
//    }
//  }
//  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    navigationController?.setNavigationBarHidden(true, animated: animated)
//  }
//  
//  private func pickVideo(from sourceType: UIImagePickerController.SourceType) {
//    let pickerController = UIImagePickerController()
//    pickerController.sourceType = sourceType
//    pickerController.mediaTypes = [kUTTypeMovie as String]
//    pickerController.videoQuality = .typeIFrame1280x720
//    if sourceType == .camera {
//      pickerController.cameraDevice = .front
//    }
//    pickerController.delegate = self
//    present(pickerController, animated: true)
//  }
//  
//  private func showVideo(at url: URL) {
//    let player = AVPlayer(url: url)
//    let playerViewController = AVPlayerViewController()
//    playerViewController.player = player
//    present(playerViewController, animated: true) {
//      player.play()
//    }
//  }
//  
//  private var pickedURL: URL?
////  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////    guard
////      let url = pickedURL
//////      let destination = segue.destination as? PlayerViewController
////      else {
////        return
////    }
////      let dest = PlayerViewController()
////      dest.videoURL = url
////      present(dest, animated: true)
//////    destination.videoURL = url
////  }
//  
////  private func showInProgress() {
////    activityIndicator.startAnimating()
////    imageView.alpha = 0.3
////    pickButton.isEnabled = false
////    recordButton.isEnabled = false
////  }
//  
//  private func showCompleted() {
////    activityIndicator.stopAnimating()
////    imageView.alpha = 1
////    pickButton.isEnabled = true
//    recordButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
//  }
//}
//
//extension PickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//    guard
//      let url = info[.mediaURL] as? URL,
//      let name = nameTextField.text
//      else {
//        print("Cannot get video URL")
//        return
//    }
//    
////    showInProgress()
//    dismiss(animated: true) {
//      self.editor.makeBirthdayCard(fromVideoAt: url, forName: name) { exportedURL in
//        self.showCompleted()
//        guard let exportedURL = exportedURL else {
//          return
//        }
//        self.pickedURL = exportedURL
//          let vc = PlayerViewController()
//          self.present(vc, animated: true)
//      }
//    }
//  }
//}
//
//extension PickerViewController: UITextFieldDelegate {
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    textField.resignFirstResponder()
//    return true
//  }
//}

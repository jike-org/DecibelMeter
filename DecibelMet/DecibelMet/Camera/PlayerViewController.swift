//import UIKit
//import AVKit
//import Photos
//
//class PlayerViewController: UIViewController {
//  var videoURL: URL!
//  
//  private var player: AVPlayer!
//  private var playerLayer: AVPlayerLayer!
//  
//  @IBOutlet weak var videoVew: UIView!
//    
//    let videoView: UIView = {
//        let view = UIView()
//        return view
//    }()
//    
//    let saveVideoButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .red
//        return button
//    }()
//  
//  private func saveVideoToPhotos() {
//    PHPhotoLibrary.shared().performChanges( {
//      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
//    }) { [weak self] (isSaved, error) in
//      if isSaved {
//        print("Video saved.")
//      } else {
//        print("Cannot save video.")
//        print(error ?? "unknown error")
//      }
//      DispatchQueue.main.async {
//        self?.navigationController?.popViewController(animated: true)
//      }
//    }
//  }
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//        
//    player = AVPlayer(url: videoURL)
//    playerLayer = AVPlayerLayer(player: player)
//    playerLayer.frame = videoView.bounds
//    videoView.layer.addSublayer(playerLayer)
//    player.play()
//    
//      setup()
//      
//    NotificationCenter.default.addObserver(
//      forName: .AVPlayerItemDidPlayToEndTime,
//      object: nil,
//      queue: nil) { [weak self] _ in self?.restart() }
//  }
//  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    navigationController?.setNavigationBarHidden(false, animated: animated)
//  }
//  
//  override func viewDidLayoutSubviews() {
//    super.viewDidLayoutSubviews()
//    
//    playerLayer.frame = videoView.bounds
//  }
//  
//  private func restart() {
//    player.seek(to: .zero)
//    player.play()
//  }
//  
//  deinit {
//    NotificationCenter.default.removeObserver(
//      self,
//      name: .AVPlayerItemDidPlayToEndTime,
//      object: nil)
//  }
//}
//
//extension PlayerViewController {
//    
//    func setup() {
//        
//        view.addSubview(videoView)
//        view.addSubview(saveVideoButton)
//        videoView.translatesAutoresizingMaskIntoConstraints = false
//        saveVideoButton.translatesAutoresizingMaskIntoConstraints = false
//        saveVideoButton.addTarget(self, action: #selector(saveVideoButonTapped), for: .touchUpInside)
//        
//        
//        NSLayoutConstraint.activate([
//            videoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            saveVideoButton.topAnchor.constraint(equalTo: view.bottomAnchor),
//            saveVideoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            saveVideoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            saveVideoButton.heightAnchor.constraint(equalToConstant: 50),
//            videoView.bottomAnchor.constraint(equalTo: saveVideoButton.topAnchor),
//            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//    }
//    
//   @objc func saveVideoButonTapped(_ sender: Any) {
//      PHPhotoLibrary.requestAuthorization { [weak self] status in
//        switch status {
//        case .authorized:
//          self?.saveVideoToPhotos()
//        default:
//          print("Photos permissions not granted.")
//          return
//        }
//      }
//    }
//
//}

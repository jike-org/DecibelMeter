//
//  CameraDB.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 13.06.22.
//

import UIKit
import AVKit
import Photos

class PlayerViewController: UIViewController {
  var videoURL: URL!
  
  private var player: AVPlayer!
  private var playerLayer: AVPlayerLayer!
  
    lazy var videoView = createView()
    lazy var videoViewTop = createView()
    lazy var videoViewBottom = createView()
    
    lazy var button = Button(style: .playOrPause, "Save")
  
  @IBAction func saveVideoButtonTapped(_ sender: Any) {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      switch status {
      case .authorized:
        self?.saveVideoToPhotos()
      default:
        print("Photos permissions not granted.")
        return
      }
    }
  }
  
  private func saveVideoToPhotos() {
    PHPhotoLibrary.shared().performChanges( {
      PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
    }) { [weak self] (isSaved, error) in
      if isSaved {
        print("Video saved.")
      } else {
        print("Cannot save video.")
        print(error ?? "unknown error")
      }
      DispatchQueue.main.async {
        self?.navigationController?.popViewController(animated: true)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
        setup()
    player = AVPlayer(url: videoURL)
    playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = videoView.bounds
    videoView.layer.addSublayer(playerLayer)
    player.play()
    
    NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: nil,
      queue: nil) { [weak self] _ in self?.restart() }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
    
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    playerLayer.frame = videoView.bounds
  }
  
  private func restart() {
    player.seek(to: .zero)
    player.play()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: .AVPlayerItemDidPlayToEndTime,
      object: nil)
  }
}

private extension PlayerViewController {
    
    func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func setup() {
        view.addSubview(videoViewTop)
        view.addSubview(videoViewBottom)
        view.addSubview(videoView)
        videoViewBottom.addSubview(button)
        NSLayoutConstraint.activate([
            videoViewTop.topAnchor.constraint(equalTo: view.topAnchor),
            videoViewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoViewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoViewTop.widthAnchor.constraint(equalToConstant: 90),
            
            videoViewBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoViewBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoViewBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoViewBottom.widthAnchor.constraint(equalToConstant: 90),
            
            videoView.topAnchor.constraint(equalTo: videoViewTop.bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: videoViewBottom.topAnchor),
            
            button.centerXAnchor.constraint(equalTo: videoViewBottom.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: videoViewBottom.centerYAnchor)
        ])
    }
}


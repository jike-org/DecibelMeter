////
////  ViewController.swift
////  DKCameraDemo
////
////  Created by ZhangAo on 15/8/30.
////  Copyright (c) 2015年 ZhangAo. All rights reserved.
////
//import UIKit
//import AVFoundation
//import DKCamera
//
//class Camera: UIViewController {
//
//    @IBOutlet var imageVew: UIImageView?
//    let imageView: UIImageView = {
//     let image = UIImageView()
//        
//        return image
//    }()
//    
//    let screenShot = Button(style: ._continue, "SHOT")
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let camera = DKCamera()
//        camera.cameraOverlayView?.addSubview(screenShot)
//        camera.contentView.addSubview(screenShot)
//        screenShot.addTarget(self, action: #selector(screenshotOf), for: .touchUpInside)
//        screenShot.layer.zPosition = 1
//        screenShot.centerXAnchor.constraint(equalTo: camera.contentView.centerXAnchor).isActive = true
//        screenShot.centerYAnchor.constraint(equalTo: camera.contentView.centerYAnchor).isActive = true
//        view.addSubview(imageView)
//        
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        
//        camera.containsGPSInMetadata = true
//          camera.showsCameraControls = true
//        camera.defaultCaptureDevice = .front
////        camera.onFaceDetection = { [unowned self, camera] (faces: [AVMetadataFaceObject]) in
////            if let face = faces.first {
////                DispatchQueue.main.async {
////                    let bounds = face.realBounds(inCamera: camera)
////                    self.faceLayer.position = bounds.origin
////                    self.faceLayer.bounds.size = bounds.size
////                }
////            }
////        }
//        camera.didCancel = { () in
//            print("didCancel")
//            
//            self.dismiss(animated: true, completion: nil)
//        }
//        
//        camera.didFinishCapturingImage = { [self] (image: UIImage?, metadata: [AnyHashable : Any]?) in
//            print("didFinishCapturingImage")
//            self.imageView.image = image
//            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//            self.dismiss(animated: true, completion: nil)
//            
//           
//        }
//
//        self.present(camera, animated: true, completion: nil)
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    @IBAction func capture() {
//        let camera = DKCamera()
//        camera.containsGPSInMetadata = true
//          camera.showsCameraControls = false
//        camera.defaultCaptureDevice = .front
//        camera.didCancel = { () in
//            print("didCancel")
//            
//            self.dismiss(animated: true, completion: nil)
//        }
//        
//        camera.didFinishCapturingImage = { (image: UIImage?, metadata: [AnyHashable : Any]?) in
//            print("didFinishCapturingImage")
//            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
//            
//            self.dismiss(animated: true, completion: nil)
//            
//            self.imageView.image = image
//            
//           
//        }
//
//        self.present(camera, animated: true, completion: nil)
//    }
//    
//    
//    
//}
//
//extension Camera {
//    
//    @objc func test() {
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .map({$0 as? UIWindowScene})
//            .compactMap({$0})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first
//        
//        guard let layer = keyWindow?.layer else { return }
//        let renderer = UIGraphicsImageRenderer(size: layer.frame.size)
//        let image = renderer.image(actions:
//                                    { context in
//            layer.render(in: context.cgContext) })
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        print("faf")
//    }
//    
//    @objc func captureScreenshot(){
////               let layer = UIApplication.shared.keyWindow!.layer
//        let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive})
//            .map({$0 as? UIWindowScene})
//            .compactMap({$0})
//            .first?.windows
//            .filter({$0.isKeyWindow}).first
//        
//               guard let layer = keyWindow?.layer else { return }
//               let scale = UIScreen.main.scale
//               // Creates UIImage of same size as view
//               UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
//               layer.render(in: UIGraphicsGetCurrentContext()!)
//               let screenshot = UIGraphicsGetImageFromCurrentImageContext()
//               UIGraphicsEndImageContext()
//               // THIS IS TO SAVE SCREENSHOT TO PHOTOS
//               UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
//     }
//    
//    @objc func screenshotOf(window: UIWindow) -> UIImage? {
//
//        UIGraphicsBeginImageContextWithOptions(window.frame.size, true, UIScreen.main.nativeScale)
//
//            guard let currentContext = UIGraphicsGetCurrentContext() else {
//                return nil
//            }
//
//            window.layer.render(in: currentContext)
//            guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
//                UIGraphicsEndImageContext()
//                return nil
//            }
//
//            UIGraphicsEndImageContext()
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            return image
//        }
//}

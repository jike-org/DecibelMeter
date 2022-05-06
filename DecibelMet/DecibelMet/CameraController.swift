//
//  CameraController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 5.05.22.
//

import Foundation
import UIKit
import AVFoundation
class CameraController: UIViewController {
    
    lazy var cameraViewController = Label(style: .heading, "Camera")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        tabBarController?.tabBar.isHidden = true
        setup()
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
}

extension CameraController {
    
    @objc func backButtonCamera() {
        let vc = TabBar()
        tabBarController?.tabBar.isHidden = false
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
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

//
//  SaveController.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 5.05.22.
//

import Foundation
import UIKit
class SaveController: UIViewController {
    
    lazy var savedViewController = Label(style: .heading, "Saved")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setup()
    }
}

extension SaveController {
    func setup(){
        view.addSubview(savedViewController)
        
        NSLayoutConstraint.activate([
            savedViewController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            savedViewController.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

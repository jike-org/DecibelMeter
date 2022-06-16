//
//  CameraDB.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 13.06.22.
//

import Foundation
import CameraManager

class DecibelMet: UIViewController {
    
    let cameraManager = CameraManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
}

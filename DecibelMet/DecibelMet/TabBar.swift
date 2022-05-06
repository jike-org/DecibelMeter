//
//  TabBar.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 5.05.22.
//

import Foundation
import UIKit


class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        selectedIndex = 1
    }
    
}


extension TabBar {
    
    private func setupView() {
        let saved = SaveController()
        let savedIcon = UITabBarItem(
            title: "Saved",
            image: UIImage(systemName: "square.and.arrow.down"),
            selectedImage: UIImage(systemName: "square.and.arrow.down")
        )
        saved.tabBarItem = savedIcon
        
        let home     = RecordView()
        let homeIcon = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house")
        )
        home.tabBarItem = homeIcon
        
        let settings     = SettingsView()
        let settingsIcon = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "seal"),
            selectedImage: UIImage(systemName: "seal")
        )
        settings.tabBarItem = settingsIcon
        
        let camera = CameraController()
        let cameraIcon = UITabBarItem(
            title: "Camera",
            image: UIImage(systemName: "camera"),
            selectedImage: UIImage(systemName: "camera")
        )
        camera.tabBarItem = cameraIcon
        
        let views = [saved, home, camera, settings]
        
        viewControllers = views
        
        self.tabBar.backgroundColor         = UIColor.black
        self.tabBar.isTranslucent           = true
        self.tabBar.barTintColor            = UIColor.white
        self.tabBar.tintColor               = .white
        self.tabBar.unselectedItemTintColor = .white
    }
    
}

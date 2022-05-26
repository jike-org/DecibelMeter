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
        selectedIndex = 2
    }
    
}


extension TabBar {
    
    private func setupView() {
        let saved = SaveController()
        let savedIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "saved"),
            selectedImage: UIImage(named: "saved")
        )
        saved.tabBarItem = savedIcon
        
        let home     = RecordView()
        let homeIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "home")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "Home")?.withRenderingMode(.alwaysOriginal)
        )
        home.tabBarItem = homeIcon
        
        let settings     = SettingsView()
        let settingsIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal)
        )
        settings.tabBarItem = settingsIcon
        
        let camera = CameraController()
        let cameraIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "camera"),
            selectedImage: UIImage(named: "camera")
        )
        camera.tabBarItem = cameraIcon
        
        let faq = CameraController()
        let faqIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "faq"),
            selectedImage: UIImage(named: "faq")
        )
        faq.tabBarItem = faqIcon
        
        let views = [faq, camera,home, saved, settings]
        
        viewControllers = views
        
        self.tabBar.backgroundColor         = UIColor.black
        self.tabBar.isTranslucent           = true
        self.tabBar.barTintColor            = UIColor.white
        self.tabBar.tintColor               = .white
        self.tabBar.unselectedItemTintColor = .white
    }
    
}

//
//  TabBar.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 5.05.22.
//

import Foundation
import UIKit

class TabBar: UITabBarController {
    
    let d = Dosimeter()
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
            image: UIImage(named: "savedTabBar"),
            selectedImage: UIImage(named: "SaveTap")?.withRenderingMode(.alwaysOriginal)
        )
        saved.tabBarItem = savedIcon
        
        let home = RecordView()
        let homeIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "homeTabBar"),
            selectedImage: UIImage(named: "homeTap")?.withRenderingMode(.alwaysOriginal)
        )
        home.tabBarItem = homeIcon
        
        let settings = SettingsView()
        let settingsIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "settingTabBar"),
            selectedImage: UIImage(named: "SettingsTap")?.withRenderingMode(.alwaysOriginal)
        )
        settings.tabBarItem = settingsIcon
        
        let camera = PhotoCameraController()
        let cameraIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "cameraTabBar"),
            selectedImage: UIImage(named: "CameraTap")?.withRenderingMode(.alwaysOriginal)
            
        )
        camera.tabBarItem = cameraIcon
        
        let faq = Dosimeter()
        let faqIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "dosimetreTabBar"),
            selectedImage: UIImage(named: "DosimetreTap")?.withRenderingMode(.alwaysOriginal)
        )
        faq.tabBarItem = faqIcon
        
        let views = [faq, camera,home, saved, settings]
        
        viewControllers = views
        
//        tabBar.backgroundColor = UIColor(named: "backgroundColor")
        tabBar.tintColor = .black
        tabBar.barTintColor = .black
        tabBar.isTranslucent = true
    }
    
}


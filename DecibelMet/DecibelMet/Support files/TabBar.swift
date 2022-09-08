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
            image: UIImage(named: "Button2-13"),
            selectedImage: UIImage(named: "Button2-20")?.withRenderingMode(.alwaysOriginal)
        )
        saved.tabBarItem = savedIcon
        
        let home = RecordView()
        let homeIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "Button2-16"),
            selectedImage: UIImage(named: "Button2-17")?.withRenderingMode(.alwaysOriginal)
        )
        home.tabBarItem = homeIcon
        
        let settings = SettingsView()
        let settingsIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "Button2-14"),
            selectedImage: UIImage(named: "Button2-19")?.withRenderingMode(.alwaysOriginal)
        )
        settings.tabBarItem = settingsIcon
        
        let camera = PhotoCameraController()
        let cameraIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "Button2-15"),
            selectedImage: UIImage(named: "Button2-18")?.withRenderingMode(.alwaysOriginal)
            
        )
        camera.tabBarItem = cameraIcon
        
        let faq = Dosimeter()
        let faqIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "Button2-12"),
            selectedImage: UIImage(named: "Button2-21")?.withRenderingMode(.alwaysOriginal)
        )
        faq.tabBarItem = faqIcon
        
        let views = [faq, camera,home, saved, settings]
        
        viewControllers = views
        
        tabBar.tintColor = .clear
        tabBar.barTintColor = .clear
        tabBar.backgroundColor = #colorLiteral(red: 0.07064444572, green: 0.07052957267, blue: 0.07489018887, alpha: 1)
        tabBar.isTranslucent = true
    }
}

extension TabBar {
    func handleDeepLink(_ deepLink: DeepLink) {
        switch deepLink {
        case .home:
            selectedIndex = 2
            present(TabBar(), animated: true)
        case .dosimeter:
            selectedIndex = 5
            present(TabBar(), animated: true)
        }
    }
}


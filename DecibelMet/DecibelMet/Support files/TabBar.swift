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
        view.backgroundColor = UIColor(named: "recordView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor(named: "recordView")
        setupView()
        selectedIndex = 2    }
}


extension TabBar {
    
    private func setupView() {
        let saved = SaveController()
        let savedIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "savedTabBar")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "SaveTap")?.withRenderingMode(.alwaysOriginal)
        )
        saved.tabBarItem = savedIcon
        
        let home = RecordView()
        let homeIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "homeTabBar")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "homeTap")?.withRenderingMode(.alwaysOriginal)
        )
        home.tabBarItem = homeIcon
        
        let settings = SettingsView()
        let settingsIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "settingTabBar")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "SettingsTap")?.withRenderingMode(.alwaysOriginal)
        )
        settings.tabBarItem = settingsIcon
        
        let camera = PickerViewController()
        let cameraIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "cameraTabBar")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "CameraTap")?.withRenderingMode(.alwaysOriginal)
        )
        camera.tabBarItem = cameraIcon
        
        let faq = Dosimeter()
        let faqIcon = UITabBarItem(
            title: "",
            image: UIImage(named: "dosimetreTabBar")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "DosimetreTap")?.withRenderingMode(.alwaysOriginal)
        )
        faq.tabBarItem = faqIcon
        
        let views = [faq, camera,home, saved, settings]
        
        viewControllers = views
        
        self.tabBarController?.tabBar.tintColor = UIColor.black
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.backgroundColor = .clear
        self.tabBar.isTranslucent = true
        self.tabBar.unselectedItemTintColor = .white
    }
    
}

extension UIScrollView {
    func setup() {
        backgroundColor = .clear
    }
}

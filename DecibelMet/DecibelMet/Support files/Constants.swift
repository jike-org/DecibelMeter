//
//  Constants.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 4.05.22.
//

import Foundation
import UIKit


public class Constants {
    
    public static let shared = Constants()
    
    public var isRecordingAtLaunchEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    public var UserThemeDark: Bool {
        if MTUserDefaults.shared.theme == .dark{
            return true
        } else {
            return false
        }
    }
    

    
    public var isFirstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    public var cameraPermission: Bool {
        get {
            UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    public var delete: Bool {
        get {
            UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    public var hasPurchased: Bool {
        get {
            UserDefaults.standard.bool(forKey: #function)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    
    
    func setExpireDate() {
        let today = Date()
        
        let expirationDate = NSCalendar.current.date(byAdding: Calendar.Component.month, value: 1, to: today)
        
        let cloudStore2 = NSUbiquitousKeyValueStore.default
        cloudStore2.set(expirationDate, forKey: "expDate")
        cloudStore2.synchronize()
        
        // create default container cloudKit
        let cloudStore = NSUbiquitousKeyValueStore.default

        if let expirationDate = cloudStore.object(forKey: "expDate") {
            let today = NSDate()
            let expireDate = expirationDate as! NSDate
            
            switch today.compare(expireDate as Date) {
              case .orderedAscending: //раньше окончания срока
                print("Подписка действует")
                hasPurchased = true

              default:
                print("Подписка закончилась или ее нет--")

                break
            }

            print("сегодня \(today) ")
            print("окончание \(expireDate) ")
            
        } else {
            hasPurchased = false
        }
    }
    
    public var isBig: Bool {
        if screenSize.height > 667 {
            return true
        } else {
            return false
        }
    }
    
    public var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
}

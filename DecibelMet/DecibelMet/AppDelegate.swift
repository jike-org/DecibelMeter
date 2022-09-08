//
//  AppDelegate.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 4.05.22.
//

import UIKit
import CoreData
import Firebase
import SwiftyStoreKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    let launchBefore = UserDefaults.standard.bool(forKey: "LaunchedBefore")
    var counter = 0
    var switc = 1
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        if UserDefaults.standard.string(forKey: "enterCounter") == nil {
            UserDefaults.standard.set(counter, forKey: "enterCounter")
        } else {
            counter = Int(UserDefaults.standard.string(forKey: "enterCounter")!)!
        }
        counter += 1
        
        UserDefaults.standard.set(counter, forKey: "enterCounter")
        
        if UserDefaults.standard.value(forKey: "FullAccess") == nil {
            let setValue = 0
            UserDefaults.standard.set(setValue, forKey: "FullAccess")
        }
            
        UserDefaults.standard.set(switc, forKey: "theme")
        
        InAppManager.share.setupPurchases { success in
            if success {
                InAppManager.share.getProductsM()
                InAppManager.share.getProductsMT()
                InAppManager.share.getProductsW()
                InAppManager.share.getProductsMT()
                InAppManager.share.getProductsY()
                InAppManager.share.getProductsYT()
            }
        }
        
        SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1we"]) { [self] result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")

            }
            else if let invalidProductId = result.invalidProductIDs.first {
            }
            else {
            }
        }
        
        SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1mo"]) { [self] result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!

            }
            else if let invalidProductId = result.invalidProductIDs.first {
            }
            else {
            }
        }
        
        SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1ye"]) { [self] result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!

            }
            else if let invalidProductId = result.invalidProductIDs.first {
            }
            else {
            }
        }
        SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1wetr"]) { [self] result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!

            }
            else if let invalidProductId = result.invalidProductIDs.first {
            }
            else {
            }
        }
        
        SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1motr"]) { [self] result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!

            }
            else if let invalidProductId = result.invalidProductIDs.first {
            }
            else {
            }
        }
        
        SwiftyStoreKit.retrieveProductsInfo(["com.decibelmeter.1yetr"]) { [self] result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!

            }
            else if let invalidProductId = result.invalidProductIDs.first {
            }
            else {
            }
        }
//        if UserDefaults.standard.string(forKey: "enterCounter") == nil {
//            UserDefaults.standard.set(cou, forKey: "enterCounter")
//        } else {
//            enterCounter = Int(UserDefaults.standard.string(forKey: "dosimeter")!)!
//        }
//
//        counter += 1
//        UserDefaults.standard.set(counter, forKey: "counter")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = MTUserDefaults.shared.theme.getUserInterfaceStyle()
        
        window?.rootViewController = OnboardingView()
        if OnboardingManager.shared.isFirstLaunch {
            window?.rootViewController = OnboardingView()
        } else {
            window?.rootViewController = TabBar()
        }
        window?.makeKeyAndVisible()

        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                for purchase in purchases {
                    switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                        // Unlock content
                    case .failed, .purchasing, .deferred:
                        break // do nothing
                    @unknown default:
                        fatalError()
                    }
                }
            }
       
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let component = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let _ = component.host else {
            return false
        }
        
         return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DecibelMet")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


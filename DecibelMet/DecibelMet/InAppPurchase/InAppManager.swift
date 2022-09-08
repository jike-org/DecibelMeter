//
//  InAppManager.swift
//  DecibelMet
//
//  Created by Stas Dashkevich on 11.07.22.
//

import Foundation
import StoreKit

class InAppManager: NSObject {
    static let share = InAppManager()
    
    private override init() {}
    
    var productW: [SKProduct] = []
    var productWT: [SKProduct] = []
    
    var productM: [SKProduct] = []
    var productMT: [SKProduct] = []
    
    var productY: [SKProduct] = []
    var productYT: [SKProduct] = []
    
    let paymentQueue = SKPaymentQueue.default()
    
    public func setupPurchases(callBack: @escaping(Bool) -> ()) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            callBack(true)
            return
        }
        callBack(false)
    }
    
    public func getProductsW() {
        let identifiersW: Set = [
            InAppPurchaseProductW.weekk.rawValue,
        
        ]

        let productRequest = SKProductsRequest(productIdentifiers: identifiersW)
        productRequest.delegate = self
        productRequest.start()
    }
    
    public func getProductsWT() {
        let identifiersWT: Set = [
            InAppPurchaseProductWT.weekTriall.rawValue,
        ]

        let productRequest = SKProductsRequest(productIdentifiers: identifiersWT)
        productRequest.delegate = self
        productRequest.start()
    }
    
    public func getProductsM() {
        let identifiersM: Set = [
            InAppPurchaseProductM.mounthh.rawValue,
          
        ]

        let productRequest = SKProductsRequest(productIdentifiers: identifiersM)
        productRequest.delegate = self
        productRequest.start()
    }
    
    public func getProductsMT() {
        let identifiersMT: Set = [
            InAppPurchaseProductMT.mounthTriall.rawValue,
        ]

        let productRequest = SKProductsRequest(productIdentifiers: identifiersMT)
        productRequest.delegate = self
        productRequest.start()
    }
    
    public func getProductsY() {
        let identifiersY: Set = [
            InAppPurchaseProductY.yearr.rawValue,
        ]

        let productRequest = SKProductsRequest(productIdentifiers: identifiersY)
        productRequest.delegate = self
        productRequest.start()
    }
    
    public func getProductsYT() {
        let identifiersYT: Set = [
            InAppPurchaseProductYT.yearTriall.rawValue,
        ]

        let productRequest = SKProductsRequest(productIdentifiers: identifiersYT)
        productRequest.delegate = self
        productRequest.start()
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
                Constants.shared.hasPurchased = true

              default:
                print("Подписка закончилась или ее нет--")

                break
            }

            print("/nсегодня \(today) ")
            print("\nокончание \(expireDate) ")
            
        } else {
            Constants.shared.hasPurchased = false
        }
    }

    
    public func purchaseW(productWith identifier1: String) {
        guard let product = productW.filter({ $0.productIdentifier == identifier1 }).first else { return }
        
        let payment = SKPayment(product: product)
        
        paymentQueue.add(payment)
    }
    
    public func purchaseWT(productWith identifier2: String) {
        guard let product = productWT.filter({ $0.productIdentifier == identifier2 }).first else { return }
        
        let payment = SKPayment(product: product)
        
        paymentQueue.add(payment)
    }
    
    
    public func purchaseM(productWith identifier3: String) {
        guard let product = productM.filter({ $0.productIdentifier == identifier3 }).first else { return }
        
        let payment = SKPayment(product: product)
        
        paymentQueue.add(payment)
    }
    public func purchaseMT(productWith identifier4: String) {
        guard let product = productMT.filter({ $0.productIdentifier == identifier4 }).first else { return }
        
        let payment = SKPayment(product: product)
        
        paymentQueue.add(payment)
    }
    
    public func purchaseY(productWith identifier5: String) {
        guard let product = productY.filter({ $0.productIdentifier == identifier5 }).first else { return }
        
        let payment = SKPayment(product: product)
        
        paymentQueue.add(payment)
    }
    public func purchaseYT(productWith identifier6: String) {
        guard let product = productYT.filter({ $0.productIdentifier == identifier6 }).first else { return }
        
        let payment = SKPayment(product: product)
        
        paymentQueue.add(payment)
    }
    
 
    
    public func restoreCompletedTrans() {
        paymentQueue.restoreCompletedTransactions()
    }
}

extension InAppManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred: break
            case .purchasing: break
            case .failed: failed(transaction: transaction)
            case .purchased: completed(transaction: transaction)
            case .restored: restored(transaction: transaction)
            @unknown default:
                print("def")
            }
        }
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        if let transError = transaction.error as NSError? {
            if transError.code != SKError.paymentCancelled.rawValue {
                print("Ошибка транзакции \(transaction.error!.localizedDescription)")
            }
        }
        
        paymentQueue.finishTransaction(transaction)
    }
    
    private func completed(transaction: SKPaymentTransaction){
        NotificationCenter.default.post(name: NSNotification.Name(transaction.payment.productIdentifier), object: nil)
        paymentQueue.finishTransaction(transaction)

        setExpireDate()
       
    }
    
    private func restored(transaction: SKPaymentTransaction){
//        print("success")
//        restoreCompletedTrans()
//        setExpireDate()
//        let access = true
//        UserDefaults.standard.set(access, forKey: "FullAccess")
    }
}


extension InAppManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.productW = response.products
        productW.forEach { print($0.localizedTitle)}
        self.productWT = response.products
        productWT.forEach { print($0.localizedTitle)}
        
        self.productM = response.products
        productM.forEach { print($0.localizedTitle)}
        self.productMT = response.products
        productMT.forEach { print($0.localizedTitle)}
        
        self.productY = response.products
        productY.forEach { print($0.localizedTitle)}
        self.productYT = response.products
        productYT.forEach { print($0.localizedTitle)}
        
        
    }
    
}

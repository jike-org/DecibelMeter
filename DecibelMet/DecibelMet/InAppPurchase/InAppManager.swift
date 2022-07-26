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
    
    var product: [SKProduct] = []
    
    let paymentQueue = SKPaymentQueue.default()
    
    public func setupPurchases(callBack: @escaping(Bool) -> ()) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            callBack(true)
            return
        }
        callBack(false)
    }
    
    public func getProducts() {
        let identifiers: Set = [
            InAppPurchaseProduct.week.rawValue,
            InAppPurchaseProduct.weekTrial.rawValue,
            
            InAppPurchaseProduct.mounth.rawValue,
            InAppPurchaseProduct.mounthTrial.rawValue,
           
            InAppPurchaseProduct.year.rawValue,
            InAppPurchaseProduct.yearTrial.rawValue,
        ]
        
        let productRequest = SKProductsRequest(productIdentifiers: identifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
    public func purchase(productWith identifier: String) {
        guard let product = product.filter({ $0.productIdentifier == identifier }).first else { return }
        
        let payment = SKPayment(product: product)
        
        paymentQueue.add(payment)
    }
    
    public func purchaseWeek(productWith identifier: String) {
        guard let product = product.filter({ $0.productIdentifier == identifier }).first else { return }
        
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
    }
    
    private func restored(transaction: SKPaymentTransaction){
        print("success")
        restoreCompletedTrans()
    }
}


extension InAppManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.product = response.products
        product.forEach { print($0.localizedTitle)}
    }
    
}

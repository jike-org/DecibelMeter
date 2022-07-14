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
}

extension InAppManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred: break
            case .purchasing: break
            case .failed: print ("failed pur")
            case .purchased: print("ok")
            case .restored: print("restore")
            @unknown default:
                print("def")
            }
        }
    }
    
    
}


extension InAppManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.product = response.products
        product.forEach { print($0.localizedTitle)}
    }
    
}

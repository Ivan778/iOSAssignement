//
//  ISProductDetailsViewControllerManager.swift
//  iOSAssignement
//
//  Created by Иван on 10/13/19.
//  Copyright © 2019 Suprynovich.Technologies. All rights reserved.
//

import Foundation

class ISProductDetailsViewControllerManager {
    private var productId: String = ""
    private var contentArray = Array<Dictionary<String, String>>()
    private let productLoader = ISProductsLoader()
    
    // MARK: Init
    convenience init(productId: String) {
        self.init()
        self.productId = productId
    }
    
    // MARK: Logic
    func loadProduct(success: @escaping (String) -> Void, failure: @escaping (String) -> Void) {
        self.productLoader.loadProduct(with: self.productId, success: { [weak self] (product) in
            self?.fillContentArray(product: product)
            success(product.image)
        }) { (errorMessage) in
            failure(errorMessage)
        }
    }
    
    private func fillContentArray(product: ProductDetailed) {
        self.contentArray.append(["key" : "product_name_key".localized(), "value" : product.name])
        self.contentArray.append(["key" : "product_price_key".localized(), "value" : "\(product.price) $"])
        self.contentArray.append(["key" : "product_description_key".localized(), "value" : product.description])
    }
    
    func content(for indexPath: IndexPath) -> Dictionary<String, String> {
        if indexPath.row < self.contentArray.count {
            return self.contentArray[indexPath.row]
        } else {
            return Dictionary<String, String>()
        }
    }
    
    func amountOfProductContents() -> Int {
        return self.contentArray.count
    }
}

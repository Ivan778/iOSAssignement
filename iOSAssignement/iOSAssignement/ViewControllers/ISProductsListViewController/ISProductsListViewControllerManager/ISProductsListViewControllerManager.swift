//
//  ISProductsListViewControllerManager.swift
//  iOSAssignement
//
//  Created by Иван on 10/6/19.
//  Copyright © 2019 Suprynovich.Technologies. All rights reserved.
//

import Foundation
import UIKit

class ISProductsListViewControllerManager {
    private let imageCache = NSCache<NSString, UIImage>()
    private var productList: ProductsList!
    private let productLoader = ISProductsLoader()
    
    func loadProducts(success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        self.productLoader.loadProductList(success: { [weak self] (products) in
            self?.productList = products
            success()
        }) { (error) in
            failure(error)
        }
    }
    
    func product(for indexPath: IndexPath) -> ProductShort {
        let emptyProduct = ProductShort(product_id: "", name: "", price: 0, image: "")
        guard let list = self.productList else { return emptyProduct }
        if indexPath.row < list.products.count {
            return list.products[indexPath.row]
        }
        return emptyProduct
    }
    
    func amountOfProducts() -> Int {
        guard let list = self.productList else { return 0 }
        return list.products.count
    }
    
    // MARK: Cache
    func cache(image: UIImage, indexPath: IndexPath) {
        let key = NSString(string: self.product(for: indexPath).product_id)
        self.imageCache.setObject(image, forKey: key)
    }
    
    func image(for indexPath: IndexPath) -> UIImage! {
        let key = NSString(string: self.product(for: indexPath).product_id)
        guard let image = self.imageCache.object(forKey: key) else { return nil }
        return image
    }
}

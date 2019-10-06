//
//  ISProductsListLoader.swift
//  iOSAssignement
//
//  Created by Иван on 10/1/19.
//  Copyright © 2019 Suprynovich.Technologies. All rights reserved.
//

import Foundation

enum NetworkPath: String {
    case productList = "/developer-application-test/cart/list"
    case productDetail = "/developer-application-test/cart/%@/detail"
}

class ISProductsLoader {
    private var host = "s3-eu-west-1.amazonaws.com"
    
    func loadProductList(success: @escaping (ProductsList) -> Void, failure: @escaping (String) -> Void) {
        ISNetworkBase.get(host: self.host, path: NetworkPath.productList.rawValue, bodyParams: nil, headerParams: nil, success: { (data) in
            let productList: ProductsList? = try? JSONDecoder().decode(ProductsList.self, from: data)
            if let result = productList {
                success(result)
            } else {
                failure("unable_to_parse".localized())
            }
        }) { (error) in
            failure(error)
        }
    }
    
    func loadProduct(with id: String, success: @escaping (ProductDetailed) -> Void, failure: @escaping (String) -> Void) {
        let path = String(format: NetworkPath.productDetail.rawValue, id)
        ISNetworkBase.get(host: self.host, path: path, bodyParams: nil, headerParams: nil, success: { (data) in
            let product: ProductDetailed? = try? JSONDecoder().decode(ProductDetailed.self, from: data)
            if let result = product {
                success(result)
            } else {
                failure("unable_to_parse".localized())
            }
        }) { (error) in
            failure(error)
        }
    }
}

//
//  ProductDetailed.swift
//  iOSAssignement
//
//  Created by Иван on 10/6/19.
//  Copyright © 2019 Suprynovich.Technologies. All rights reserved.
//

import Foundation

struct ProductDetailed: Codable {
    var product_id: String
    var name: String
    var price: Int
    var image: String
    var description: String
}

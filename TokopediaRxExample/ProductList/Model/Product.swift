//
//  Product.swift
//  TokopediaRxExample
//
//  Created by GITS on 08/11/19.
//  Copyright © 2019 Muhammad Arif. All rights reserved.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let name: String
    let imageUri: String
    let price: String
}

struct ProductListResponse: Decodable {
    let data: [Product]
}

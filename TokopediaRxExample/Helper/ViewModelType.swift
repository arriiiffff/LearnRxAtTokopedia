//
//  ViewModelType.swift
//  TokopediaRxExample
//
//  Created by GITS on 08/11/19.
//  Copyright © 2019 Muhammad Arif. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(pmin: String, pmax: String, wholeSale: String, official: String, fshop:String, input: Input) -> Output
}

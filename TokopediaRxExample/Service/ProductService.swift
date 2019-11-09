//
//  ProductService.swift
//  TokopediaRxExample
//
//  Created by GITS on 08/11/19.
//  Copyright © 2019 Muhammad Arif. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ProductServiceError: Error {
    case missingData
}

protocol ProductServiceProtocol {
    func fetchProducts(completion: @escaping ((Result<[Product], Error>) -> Void))
    
    func reactiveFetchProducts(pmin: String, pmax: String, wholeSale: String, official: String, fshop:String) -> Observable<[Product]>
}

class NetworkProductService: ProductServiceProtocol {
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    func fetchProducts(completion: @escaping ((Result<[Product], Error>) -> Void)) {
        let url = URL(string: "https://gist.githubusercontent.com/99ridho/cbbeae1fa014522151e45a766492233c/raw/8935d40ae0650f12b452d6a5e9aa238a02b05511/contacts.json")!
        
        let task = URLSession.shared.dataTask(with: url) { [jsonDecoder] (data, response, error) in
            if let theError = error {
                completion(.failure(theError))
                return
            }
            
            guard let theData = data else {
                completion(.failure(ProductServiceError.missingData))
                return
            }
            
            do {
                let response = try jsonDecoder.decode(ProductListResponse.self, from: theData)
                let contacts = response.data

                completion(.success(contacts))
            } catch (let decodeError) {
                completion(.failure(decodeError))
            }
        }
        
        task.resume()
    }
    
    func reactiveFetchProducts(pmin: String, pmax: String, wholeSale: String, official: String, fshop:String) -> Observable<[Product]> {
        Observable<Any>.empty()
        let url = URL(string: "https://ace.tokopedia.com/search/v2.5/product?q=samsung&pmin=\(pmin)&pmax=\(pmax)&wholesale=\(wholeSale)&official=\(official)&fshop=\(fshop)&start=0&rows=10")!
        
        let urlRequest = URLRequest(url: url)
        
        let response = URLSession.shared.rx
            .data(request: urlRequest)
            .flatMapLatest { data -> Observable<ProductListResponse> in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do{
                    let resultData = try decoder.decode(ProductListResponse.self, from: data)
                    return Observable.just(resultData)
                } catch (let decodeError) {
                    return Observable.error(decodeError)
                }
        }
        
        let contacts = response.map { $0.data }
        
        return contacts
    }
}


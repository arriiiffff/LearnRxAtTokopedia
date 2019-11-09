//
//  ReactiveProductListModel.swift
//  TokopediaRxExample
//
//  Created by GITS on 08/11/19.
//  Copyright © 2019 Muhammad Arif. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ReactiveProductListViewModel: ViewModelType {
    let service: ProductServiceProtocol
    init(service: ProductServiceProtocol = NetworkProductService()) {
        self.service = service
    }
    
    struct Input {
        let didLoadTrigger: Driver<Void>
        let didTapCellTrigger: Driver<IndexPath>
        let pullToRefreshTrigger: Driver<Void>
    }
    
    struct Output {
        let productListCellData: Driver<[ProductListCollectionCellData]>
        let errorData: Driver<String>
        let selectedIndex: Driver<(index: IndexPath, model: ProductListCollectionCellData)>
        let isLoading: Driver<Bool>
    }
    
    func transform(pmin: String, pmax: String, wholeSale: String, official: String, fshop:String, input: Input) -> Output {
        let errorMessage = PublishSubject<String>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        let fetchDataTrigger = Driver.merge( input.didLoadTrigger, input.pullToRefreshTrigger)
        
        let fetchData = fetchDataTrigger
            .do(onNext: { _ in
                isLoading.accept(true)
            })
            .flatMapLatest { [service] _ -> Driver<[Product]> in
            service
                .reactiveFetchProducts(pmin: pmin, pmax: pmax, wholeSale: wholeSale, official: official, fshop:fshop)
                .do(onNext: { _ in
                    isLoading.accept(false)
                }, onError: { error in
                    errorMessage.onNext(error.localizedDescription)
                    isLoading.accept(false)
                })
                .asDriver { _ -> Driver<[Product]> in
                    Driver.empty()
            }
        }
        let productListCellData = fetchData
            .map { products -> [ProductListCollectionCellData] in
                products.map { product -> ProductListCollectionCellData in
                    ProductListCollectionCellData(imageUri: product.imageUri, name: product.name, price: product.price)
                }
                
        }
        
        let errorMessageDriver =  errorMessage
            .asDriver { error -> Driver<String> in
                Driver.empty()
        }
        
        let selectedIndexCell = input
            .didTapCellTrigger
            .withLatestFrom(productListCellData) {
                index, products -> (index: IndexPath, model: ProductListCollectionCellData) in
                return (index: index, model: products[index.row])
        }
        
        return Output(productListCellData: productListCellData, errorData: errorMessageDriver, selectedIndex: selectedIndexCell, isLoading: isLoading.asDriver())
    }
    
}



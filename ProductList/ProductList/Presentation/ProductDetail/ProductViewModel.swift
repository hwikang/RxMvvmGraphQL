//
//  ProductViewModel.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/01.
//

import Foundation
import RxSwift
final class ProductViewModel {
    private let productList = PublishSubject<ProductQuery.Data.Product>()

    struct Input {
        
    }
    
    struct Output {
        let productList: Observable<ProductQuery.Data.Product>
    }
    private let dataSource: ProductDataSource
    private let id: String
    
    init(id: String, dataSource: ProductDataSource) {
        self.id = id
        self.dataSource = dataSource
        productDetail()
    }
    
    func transform(input: Input) -> Output {
        return Output(productList: productList.asObservable())
    }
    
    func productDetail() {

        dataSource.productDetail(id: self.id) {[weak self] fetchResult in
            switch fetchResult {
            case .success(let result):
                if let error = result.errors?.first as? Error {
                    self?.productList.onError(error)
                }
                if let product = result.data?.product {
                    self?.productList.onNext(product)
                }
            case .failure(let error):
                self?.productList.onError(error)
            }
        }
    }
    
    
}

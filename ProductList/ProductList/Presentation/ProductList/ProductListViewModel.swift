//
//  ProductListViewModel.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/10/29.
//

import Foundation
import RxSwift
import RxRelay

final class ProductListViewModel {
    // MARK: Property
    private let dataSource: ProductDataSource
    private let productList = PublishSubject<[ProductListQuery.Data.ProductList.ItemList]>()
    init(dataSource: ProductDataSource) {
        self.dataSource = dataSource
    }
    struct Input {
        
    }
    struct Output {
        let productList: Observable<[ProductListQuery.Data.ProductList.ItemList]>
    }
    
    // MARK: Public function
    func transform(input: Input) -> Output {
        return Output(productList: productList.asObservable())
    }
    
    func fetchProductList() {
        dataSource.fetchProductList {[weak self] fetchResult in
            switch fetchResult {
            case .success(let result):
                if let fetchList = result.data?.productList.itemList {
                    self?.productList.onNext(fetchList)
                }
            case .failure(let error):
                self?.productList.onError(error)
            }
        }
    }

}

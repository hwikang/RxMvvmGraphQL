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
    private let disposeBag = DisposeBag()
    private let dataSource: ProductDataSource
    private let productList = PublishSubject<[ProductListQuery.Data.ProductList.ItemList]>()
    
    init(dataSource: ProductDataSource) {
        self.dataSource = dataSource
        fetchProductList()
    }
    struct Input {
        let needUpdateList: Observable<Bool>
    }
    struct Output {
        let productList: Observable<[ProductListQuery.Data.ProductList.ItemList]>
    }
    
    func transform(input: Input) -> Output {
        input.needUpdateList.bind {[weak self] needUpdate in
            if needUpdate {self?.fetchProductList()}
        }.disposed(by: disposeBag)
        return Output(productList: productList.asObservable())
    }
    
    private func fetchProductList() {
        dataSource.fetchProductList {[weak self] fetchResult in
            switch fetchResult {
            case .success(let result):
                if let error = result.errors?.first as? Error {
                    self?.productList.onError(error)
                }
                if let fetchList = result.data?.productList.itemList {
                    self?.productList.onNext(fetchList)
                }
            case .failure(let error):
                print(error)
                self?.productList.onError(error)

            }
        }
    }
}

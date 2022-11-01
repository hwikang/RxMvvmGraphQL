//
//  CreatePopupViewMdel.swift
//  ProductList
//
//  Created by Simon on 2022/10/31.
//

import Foundation
import RxSwift

final class CreatePopupViewModel {
    private let dataSource: ProductDataSource
    private let supplierList = PublishSubject<[SupplierListQuery.Data.SupplierList.ItemList]?>()
    struct Input {
    }
    struct Output {
        let supplierList: Observable<[SupplierListQuery.Data.SupplierList.ItemList]?>
    }
    init(dataSource: ProductDataSource) {
        self.dataSource = dataSource
    }
    
    func transform(input: Input) -> Output {
        return Output(supplierList: supplierList.asObservable())
    }
    
    func fetchSupplier() {
        dataSource.fetchSuppliers {[weak self] fetchResult in
            switch fetchResult {
            case .success(let result):
                let list = result.data?.supplierList.itemList
                self?.supplierList.onNext(list)
            case .failure(let error):
                print(error)
                self?.supplierList.onError(error)
            }
        }
    }
    
    func createProduct() {
    }
}

//
//  CreatePopupViewMdel.swift
//  ProductList
//
//  Created by Simon on 2022/10/31.
//

import Foundation
import RxSwift
import RxCocoa

final class CreatePopupViewModel {
    private let disposeBag = DisposeBag()
    private let dataSource: ProductDataSource
    private let supplierList = PublishSubject<[SupplierListQuery.Data.SupplierList.ItemList]?>()
    private let createDone = PublishRelay<Bool>()

    struct Input {
        let createInput: Observable<CreateProductInput>
    }
    struct Output {
        let supplierList: Observable<[SupplierListQuery.Data.SupplierList.ItemList]?>
        let createDone: Driver<Bool>
        
    }
    init(dataSource: ProductDataSource) {
        self.dataSource = dataSource
        fetchSupplier()
    }
    
    func transform(input: Input) -> Output {
        input.createInput.bind {[weak self] input in
            self?.createProduct(input: input)
        }.disposed(by: disposeBag)
        return Output(supplierList: supplierList.asObservable(),
                      createDone: createDone.asDriver(onErrorJustReturn: false)
        )
    }
    
    private func fetchSupplier() {
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
    
    private func createProduct(input: CreateProductInput) {
        dataSource.createProduct(input: input) {[weak self] mutateResult in
            switch mutateResult {
            case .success(let result):
                self?.createDone.accept(true)
                print(result.data?.createProduct.id)
            case .failure(let error):
                print(error)
                self?.createDone.accept(false)

            }
        }
    }
    
}

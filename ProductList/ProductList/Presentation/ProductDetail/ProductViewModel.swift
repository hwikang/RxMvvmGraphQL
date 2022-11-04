//
//  ProductViewModel.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/01.
//

import Foundation
import RxSwift
final class ProductViewModel {
    private let disposeBag = DisposeBag()
    private let productDetail = PublishSubject<ProductQuery.Data.Product>()
    private let deleteDone = PublishSubject<Bool>()

    struct Input {
        let deleteProduct: Observable<Bool>
        let needUpdateProduct: Observable<Bool>
    }
    
    struct Output {
        let productDetail: Observable<ProductQuery.Data.Product>
        let deleteDone: Observable<Bool>
    }
    private let dataSource: ProductDataSource
    private let id: String
    
    init(id: String, dataSource: ProductDataSource) {
        self.id = id
        self.dataSource = dataSource
        getProductDetail()
    }
    
    func transform(input: Input) -> Output {
        
        input.deleteProduct.bind {[weak self] _ in
            self?.deleteProduct()
        }.disposed(by: disposeBag)
        
        input.needUpdateProduct.bind { [weak self] _ in
            self?.getProductDetail()
        }.disposed(by: disposeBag)
        
        return Output(productDetail: productDetail.asObservable(),
                      deleteDone: deleteDone.asObservable())
    }
    
    private func getProductDetail() {
        dataSource.productDetail(id: self.id) {[weak self] fetchResult in
            switch fetchResult {
            case .success(let result):
                if let error = result.errors?.first as? Error {
                    self?.productDetail.onError(error)
                }
                if let product = result.data?.product {
                    self?.productDetail.onNext(product)
                }
            case .failure(let error):
                self?.productDetail.onError(error)
            }
        }
    }
    
    private func deleteProduct() {
        dataSource.deleteProduct(id: id) {[weak self] deleteResult in
            print(deleteResult)
            switch deleteResult {
            case .success(let result):
                if let error = result.errors?.first as? Error {
                    self?.deleteDone.onError(error)
                } else {
                    self?.deleteDone.onNext(true)
                }
            case .failure(let error):
                self?.deleteDone.onError(error)

            }
        }
    }
}

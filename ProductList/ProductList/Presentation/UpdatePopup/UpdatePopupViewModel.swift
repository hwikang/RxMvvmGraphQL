//
//  UpdatePopupViewModel.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/02.
//

import Foundation
import RxSwift
import RxCocoa
import Apollo
final class UpdatePopupViewModel {
    private let disposeBag = DisposeBag()
    private let dataSource: ProductDataSource
    private let updateDone = PublishSubject<UpdateProductMutation.Data.UpdateProduct>()

    struct Input {
        let updateInput: Observable<UpdateProductInput>

    }
    struct Output {
        let updateDone: Observable<UpdateProductMutation.Data.UpdateProduct>

    }
    init(dataSource: ProductDataSource) {
        self.dataSource = dataSource
    }
    
    func transform(input: Input) -> Output {
        input.updateInput.bind {[weak self] input in
            self?.updateProduct(input: input)
        }.disposed(by: disposeBag)
        
        return Output(
            updateDone: updateDone.asObservable()
        )
    }
    
    private func updateProduct(input: UpdateProductInput) {
        dataSource.updateProduct(input: input) {[weak self] mutateResult in
            switch mutateResult {
            case .success(let result):
                if let error = result.errors?.first as? Error {
                    self?.updateDone.onError(error)
                    return
                }
                if let product = result.data?.updateProduct {
                    self?.updateDone.onNext(product)
                }
            case .failure(let error):
                self?.updateDone.onError(error)
            }
        }
    }
    
}

//
//  UpdatePopupViewModel.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/02.
//

import Foundation

import Foundation
import RxSwift
import RxCocoa
import Apollo
final class UpdatePopupViewModel {
    private let disposeBag = DisposeBag()
    private let dataSource: ProductDataSource

    struct Input {
    }
    struct Output {
        
    }
    init(dataSource: ProductDataSource) {
        self.dataSource = dataSource
    }
    
    func transform(input: Input) -> Output {
        
        return Output(
        )
    }
    
    
    
}

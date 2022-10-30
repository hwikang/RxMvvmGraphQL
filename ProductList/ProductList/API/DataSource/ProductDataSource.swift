//
//  ProductDataSource.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/10/29.
//

import Foundation
import Apollo

protocol ProductDataSource {
    func fetchProductList(callBack: @escaping (Result<GraphQLResult<ProductListQuery.Data>, Error>) -> Void )
}

final class ProductDataSourceImpl: ProductDataSource {
    func fetchProductList(callBack: @escaping (Result<GraphQLResult<ProductListQuery.Data>, Error>) -> Void ) {
        let query = ProductListQuery(id_list: nil)
        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely, contextIdentifier: nil, queue: .main) { fetchResult in
            callBack(fetchResult)
        }
    }
    
}

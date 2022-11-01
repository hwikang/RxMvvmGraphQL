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
    func fetchSuppliers(callBack: @escaping (Result<GraphQLResult<SupplierListQuery.Data>, Error>) -> Void )
    func createProduct(input: CreateProductInput, callBack: @escaping (Result<GraphQLResult<CreateProductMutation.Data>, Error>) -> Void)
    func productDetail(id: String, callBack: @escaping (Result<GraphQLResult<ProductQuery.Data>, Error>) -> Void)
}

final class ProductDataSourceImpl: ProductDataSource {
    func fetchProductList(callBack: @escaping (Result<GraphQLResult<ProductListQuery.Data>, Error>) -> Void ) {
        let query = ProductListQuery(id_list: nil)
        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely, contextIdentifier: nil, queue: .main) { fetchResult in
            callBack(fetchResult)
        }
    }
    func fetchSuppliers(callBack: @escaping (Result<GraphQLResult<SupplierListQuery.Data>, Error>) -> Void ) {
        let query = SupplierListQuery(id_list: nil)
        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely, contextIdentifier: nil, queue: .main) { fetchResult in
            callBack(fetchResult)
        }
    }
    func createProduct(input: CreateProductInput, callBack: @escaping (Result<GraphQLResult<CreateProductMutation.Data>, Error>) -> Void) {
        let mutation = CreateProductMutation(input: input)
        Network.shared.apollo.perform(mutation: mutation, publishResultToStore: true, queue: .main) { result in
            callBack(result)
        }
    }
    func productDetail(id: String, callBack: @escaping (Result<GraphQLResult<ProductQuery.Data>, Error>) -> Void) {
        let query = ProductQuery(id: id)
        Network.shared.apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely, contextIdentifier: nil, queue: .main) { fetchResult in
            callBack(fetchResult)
        }

    }
}

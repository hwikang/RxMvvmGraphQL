//
//  Network.swift
//  ProductList
//
//  Created by Simon on 2022/10/28.
//

import Foundation
import Apollo

final class Network {
    static let shared = Network()
    
    private(set) lazy var apollo: ApolloClient = {
        guard let url = URL(string: "https://test.recruit.croquis.com:28501"),
        let uuid = UIDevice.current.identifierForVendor?.uuidString else { fatalError("Create Apollo Client Error")}

        let store = ApolloStore()

        let interceptorProvider = NetworkInterceptorsProvider(
                   interceptors: [UUIDInterceptor(uuid: uuid)],
                   store: store
               )
       let networkTransport = RequestChainNetworkTransport(interceptorProvider: interceptorProvider, endpointURL: url)
        
        return ApolloClient(networkTransport: networkTransport, store: store)

    }()
}

final class UUIDInterceptor: ApolloInterceptor {
  
    let uuid: String
    init(uuid: String) {
        self.uuid = uuid
    }
    
    func interceptAsync<Operation>(chain: RequestChain, request: HTTPRequest<Operation>, response: HTTPResponse<Operation>?, completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) where Operation: GraphQLOperation {
        
        request.addHeader(name: "Croquis-UUID", value: self.uuid)
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
    
}

final class NetworkInterceptorsProvider: DefaultInterceptorProvider {
    let interceptors: [ApolloInterceptor]
    init(interceptors: [ApolloInterceptor], store: ApolloStore) {
        self.interceptors = interceptors
        super.init(store: store)
    }
    
    override func interceptors<Operation>(for operation: Operation) -> [ApolloInterceptor] where Operation: GraphQLOperation {
        var superInterceptors = super.interceptors(for: operation)
        self.interceptors.forEach { interceptor in
            superInterceptors.insert(interceptor, at: 0)
        }
        return superInterceptors
    }
    
}

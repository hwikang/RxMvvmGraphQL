### API URL

Application/Config 폴더안 configuration 파일에

url이 정의 되어있으며 이를 사용하고 있습니다.

```jsx
SERVER_URL = API주소
```

헤더 정보는 interceptor 통해 담고있으며 

디바이스의 uuid 를 값으로 가지고있습니다.

```jsx
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
```

### API

```jsx
├── API
│   ├── DataSource
│   │   └── ProductDataSource.swift
│   ├── Mutation
│   │   ├── CreateProductMutation.graphql
│   │   ├── DeleteProductMutation.graphql
│   │   └── UpdateProductMutation.graphql
│   ├── Network.swift
│   └── Query
│       ├── ProductListQuery.graphql
│       ├── ProductQuery.graphql
│       └── SupplierListQuery.graphql
```

ProductDataSource 에는 Product와 관련한 쿼리& 뮤테이션 함수들이 정의되어있습니다. 

```jsx
protocol ProductDataSource {
    func fetchProductList(callBack: @escaping (Result<GraphQLResult<ProductListQuery.Data>, Error>) -> Void )
    func fetchSuppliers(callBack: @escaping (Result<GraphQLResult<SupplierListQuery.Data>, Error>) -> Void )
    func createProduct(input: CreateProductInput, callBack: @escaping (Result<GraphQLResult<CreateProductMutation.Data>, Error>) -> Void)
    func productDetail(id: String, callBack: @escaping (Result<GraphQLResult<ProductQuery.Data>, Error>) -> Void)
    func deleteProduct(id: String, callBack: @escaping (Result<GraphQLResult<DeleteProductMutation.Data>, Error>) -> Void)
    func updateProduct(input: UpdateProductInput, callBack: @escaping (Result<GraphQLResult<UpdateProductMutation.Data>, Error>) -> Void) 
}
```

### API 에러

```jsx
private let productList = PublishSubject<[ProductListQuery.Data.ProductList.ItemList]>()
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
              self?.productList.onError(error)

          }
      }
  }

//VC
output.productList          
  .catch({ error in
      self.present(Dialog.getDialog(title: "에러", message: error.localizedDescription), animated: true)
      return Observable.just([])
  })
```

서버 요청에 따른 응답값에 대한 처리는 

onError() 를 통해 Viewcontroller에 전달되며

팝업을 통해 메시지를 전달하도록 처리 하였습니다.

### Delegate

Viewcontroller 간에 전달해야하는 이벤트가 있는경우 delegate패턴을 적용 했습니다. 

ex> 상품 생성 완료시 → 상품 리스트 갱신

 상품삭제 완료시 → 상품 리스트 갱신

상품 수정 완료시 → 상품 정보 갱신 

```jsx
output.createDone
    .bind(onNext: {[weak self] isDone in
    if isDone {
        self?.delegate?.updateList()
        self?.dismiss(animated: true)
    }
}).disposed(by: disposeBag)
```

### Input & Output

```jsx
final class ProductListViewModel {

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
}
```

ViewController ↔ ViewModel 간 협업은 Input Output 을 통합니다.

Input은 ViewController → ViewModel로의 이벤트

Output은 ViewModel→ ViewController 로 이벤트들 입니다.

ViewController로 부터 받아온 input 은 transform() 함수에

바인딩 되어 사용하며 ViewController 에서는 받아온 output을 

bindViewModel() 함수에 바인딩 하여 사용합니다.

```jsx
private func bindViewModel() {
    let input = ProductListViewModel.Input(needUpdateList: needUpdateList.asObservable())
    let output = viewModel.transform(input: input)
    
    output.productList
        .catch({ error in
            self.present(Dialog.getDialog(title: "에러", message: error.localizedDescription), animated: true)
            return Observable.just([])
        })
        .bind(to: productListTableView.rx.items(cellIdentifier: "ProductListCell", cellType: ProductListTableViewCell.self)) {[weak self] (_, element, cell) in
            cell.configure(id: element.id, nameKo: element.nameKo, nameEn: element.nameEn, price: element.price, supplier: element.supplier?.name)
            self?.loadingView?.removeFromSuperview()
        }
        .disposed(by: disposeBag)
}
```

// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// createProduct의 입력
public struct CreateProductInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - supplierId: 공급사 ID
  ///   - nameKo: 한국어 상품명
  ///   - price: 가격
  public init(supplierId: GraphQLID, nameKo: String, price: Int) {
    graphQLMap = ["supplier_id": supplierId, "name_ko": nameKo, "price": price]
  }

  /// 공급사 ID
  public var supplierId: GraphQLID {
    get {
      return graphQLMap["supplier_id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "supplier_id")
    }
  }

  /// 한국어 상품명
  public var nameKo: String {
    get {
      return graphQLMap["name_ko"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name_ko")
    }
  }

  /// 가격
  public var price: Int {
    get {
      return graphQLMap["price"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "price")
    }
  }
}

public final class CreateProductMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation createProduct($input: CreateProductInput!) {
      createProduct(input: $input) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "createProduct"

  public var input: CreateProductInput

  public init(input: CreateProductInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createProduct", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreateProduct.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createProduct: CreateProduct) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createProduct": createProduct.resultMap])
    }

    /// 상품을 생성한다
    public var createProduct: CreateProduct {
      get {
        return CreateProduct(unsafeResultMap: resultMap["createProduct"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createProduct")
      }
    }

    public struct CreateProduct: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Product"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "Product", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// 기본 키
      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class ProductListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query productList($id_list: [ID!]) {
      product_list(id_list: $id_list) {
        __typename
        item_list {
          __typename
          id
          name_ko
          name_en
          price
          supplier {
            __typename
            name
          }
        }
      }
    }
    """

  public let operationName: String = "productList"

  public var id_list: [GraphQLID]?

  public init(id_list: [GraphQLID]?) {
    self.id_list = id_list
  }

  public var variables: GraphQLMap? {
    return ["id_list": id_list]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("product_list", arguments: ["id_list": GraphQLVariable("id_list")], type: .nonNull(.object(ProductList.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(productList: ProductList) {
      self.init(unsafeResultMap: ["__typename": "Query", "product_list": productList.resultMap])
    }

    /// 주어진 조건 모두에 일치하는 상품 목록을 받는다.
    /// 조건이 주어지지 않으면 모든 상품을 반환한다.
    public var productList: ProductList {
      get {
        return ProductList(unsafeResultMap: resultMap["product_list"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "product_list")
      }
    }

    public struct ProductList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ProductList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("item_list", type: .nonNull(.list(.nonNull(.object(ItemList.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(itemList: [ItemList]) {
        self.init(unsafeResultMap: ["__typename": "ProductList", "item_list": itemList.map { (value: ItemList) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// 상품 목록
      public var itemList: [ItemList] {
        get {
          return (resultMap["item_list"] as! [ResultMap]).map { (value: ResultMap) -> ItemList in ItemList(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: ItemList) -> ResultMap in value.resultMap }, forKey: "item_list")
        }
      }

      public struct ItemList: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Product"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name_ko", type: .scalar(String.self)),
            GraphQLField("name_en", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(Int.self)),
            GraphQLField("supplier", type: .object(Supplier.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, nameKo: String? = nil, nameEn: String? = nil, price: Int? = nil, supplier: Supplier? = nil) {
          self.init(unsafeResultMap: ["__typename": "Product", "id": id, "name_ko": nameKo, "name_en": nameEn, "price": price, "supplier": supplier.flatMap { (value: Supplier) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// 기본 키
        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// 한국어 상품명
        public var nameKo: String? {
          get {
            return resultMap["name_ko"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name_ko")
          }
        }

        /// 영어 상품명
        public var nameEn: String? {
          get {
            return resultMap["name_en"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name_en")
          }
        }

        /// 가격
        public var price: Int? {
          get {
            return resultMap["price"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "price")
          }
        }

        /// 공급사
        public var supplier: Supplier? {
          get {
            return (resultMap["supplier"] as? ResultMap).flatMap { Supplier(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "supplier")
          }
        }

        public struct Supplier: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Supplier"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String) {
            self.init(unsafeResultMap: ["__typename": "Supplier", "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// 공급사명
          public var name: String {
            get {
              return resultMap["name"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }
      }
    }
  }
}

public final class SupplierListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query supplierList($id_list: [ID!]) {
      supplier_list(id_list: $id_list) {
        __typename
        item_list {
          __typename
          name
          id
        }
      }
    }
    """

  public let operationName: String = "supplierList"

  public var id_list: [GraphQLID]?

  public init(id_list: [GraphQLID]?) {
    self.id_list = id_list
  }

  public var variables: GraphQLMap? {
    return ["id_list": id_list]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("supplier_list", arguments: ["id_list": GraphQLVariable("id_list")], type: .nonNull(.object(SupplierList.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(supplierList: SupplierList) {
      self.init(unsafeResultMap: ["__typename": "Query", "supplier_list": supplierList.resultMap])
    }

    /// 주어진 조건 모두에 일치하는 공급사 목록을 받는다.
    /// 조건이 주어지지 않으면 모든 공급사를 반환한다.
    public var supplierList: SupplierList {
      get {
        return SupplierList(unsafeResultMap: resultMap["supplier_list"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "supplier_list")
      }
    }

    public struct SupplierList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SupplierList"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("item_list", type: .nonNull(.list(.nonNull(.object(ItemList.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(itemList: [ItemList]) {
        self.init(unsafeResultMap: ["__typename": "SupplierList", "item_list": itemList.map { (value: ItemList) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// 공급사 목록
      public var itemList: [ItemList] {
        get {
          return (resultMap["item_list"] as! [ResultMap]).map { (value: ResultMap) -> ItemList in ItemList(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: ItemList) -> ResultMap in value.resultMap }, forKey: "item_list")
        }
      }

      public struct ItemList: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Supplier"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String, id: GraphQLID) {
          self.init(unsafeResultMap: ["__typename": "Supplier", "name": name, "id": id])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// 공급사명
        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// 기본 키
        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }
      }
    }
  }
}

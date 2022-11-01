//
//  ProductDetailViewController.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/01.
//

import Foundation
import UIKit
import RxSwift

final class ProductViewController: UIViewController {
//    # 한국어/영어 상품명, 요약설명, 가격, 공급사를 표시합니다.
    private let disposeBag = DisposeBag()
    private lazy var viewModel = ProductViewModel(id: self.productId, dataSource: ProductDataSourceImpl())
    private let productId: String
    
    // MARK: - UI
//    lazy var scrollView: UIScrollView = {
//        let scroll = UIScrollView()
//        scroll.isScrollEnabled = true
//        scroll.backgroundColor = .blue
//        return scroll
//    }()
//
//    lazy var stackView: UIStackView = {
//       let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.backgroundColor = .red
//        return stackView
//    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        return label
    }()
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
//        label.sizeToFit()
        label.backgroundColor = .yellow
        return label
    }()
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var supplierLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(productId: String) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
   
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = ProductViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.productList.bind {[weak self] product in
            print(product)
            self?.nameLabel.text = "\(product.nameKo ?? "") \(product.nameEn ?? "")"
            self?.descLabel.text = "dasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasddasdasdasdasdasdasd\(product.descriptionKo ?? "") \(product.descriptionEn ?? "")"
            self?.priceLabel.text = "\(product.price ?? 0) 원"
            self?.supplierLabel.text = "\(product.supplier?.name ?? "")"
            

        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductViewController {
    private func setUI() {
//        self.view.addSubview(scrollView)
//        scrollView.addSubview(stackView)
        view.addSubview(nameLabel)
        view.addSubview(descLabel)
        view.addSubview(priceLabel)
        view.addSubview(supplierLabel)
        setConstraint()
    }
    private func setConstraint() {
//        scrollView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(30)
//            make.leading.equalToSuperview().offset(10)
//            make.trailing.equalToSuperview().offset(-10)
//            make.bottom.equalToSuperview()
//        }
//        stackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)

        }
        supplierLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
        }
        
    }
}

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
    private let disposeBag = DisposeBag()
    private lazy var viewModel = ProductViewModel(id: self.productId, dataSource: ProductDataSourceImpl())
    private let productId: String
    
    // MARK: - UI
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        return scroll
    }()

    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let supplierLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.backgroundColor = .systemRed
        return button
    }()
    
    init(productId: String) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
   
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setUI()
        bindView()
        bindViewModel()
    }
    private func bindView() {
        deleteButton.rx.tap.bind { [weak self] in
            print("Tap")
            let dialog = Dialog.getQuestionDialog(title: "삭제", message: "상품을 삭제 하시겠습니까?") {
                //Todo: Delete
                
            }
            self?.present(dialog, animated: true)
        }.disposed(by: disposeBag)
    }
    private func bindViewModel() {
        let input = ProductViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.productList
            .catch { [weak self] error in
                self?.present(Dialog.getDialog(title: "에러", message: error.localizedDescription), animated: true)
                return Observable.just(ProductQuery.Data.Product())
            }
            .bind {[weak self] product in
                DispatchQueue.main.async {
                    self?.nameLabel.text = "\(product.nameKo ?? "") \(product.nameEn ?? "")"
                    self?.descLabel.text = "\(product.descriptionKo ?? "") \(product.descriptionEn ?? "")"
                    self?.priceLabel.text = "\(product.price ?? 0) 원"
                    self?.supplierLabel.text = "\(product.supplier?.name ?? "")"
                }
            
        }.disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductViewController {
    private func setUI() {
        self.view.addSubview(scrollView)
        self.view.addSubview(deleteButton)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(supplierLabel)
        setConstraint()
    }
    private func setConstraint() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()

        }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.width.equalTo(view.snp.width).offset(-20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.width.equalTo(view.snp.width).offset(-20)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom)
            make.width.equalToSuperview()

        }
        supplierLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.width.equalToSuperview()

        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.width.height.equalTo(60)
        }
    }
}

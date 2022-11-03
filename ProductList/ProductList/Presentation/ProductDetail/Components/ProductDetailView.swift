//
//  ProductView.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/03.
//

import UIKit

final class ProductDetailView: UIView {

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
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    public func setLabelText(product: ProductQuery.Data.Product) {
        nameLabel.text = "\(product.nameKo ?? "") \(product.nameEn ?? "")"
        descLabel.text = "\(product.descriptionKo ?? "") \(product.descriptionEn ?? "")"
        priceLabel.text = "\(product.price ?? 0) 원"
        supplierLabel.text = "\(product.supplier?.name ?? "")"
    }
    
    private func setUI() {
        self.addSubview(scrollView)
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
            make.width.equalTo(self.snp.width).offset(-20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.width.equalTo(self.snp.width).offset(-20)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom)
            make.width.equalToSuperview()

        }
        supplierLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom)
            make.width.equalToSuperview()

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
        stackView.spacing = 8
        return stackView
    }()
    
    private let nameKoTitle: UILabel = {
       let label = UILabel()
        label.text = "한국어 상품명"
        return label
    }()
    private let nameEnTitle: UILabel = {
       let label = UILabel()
        label.text = "영어 상품명"
        return label
    }()
    private let descKoTitle: UILabel = {
       let label = UILabel()
        label.text = "한국어 상품 요약 설명"
        return label
    }()
    private let descEnTitle: UILabel = {
       let label = UILabel()
        label.text = "영어 상품 요약 설명"
        return label
    }()
    private let priceTitle: UILabel = {
       let label = UILabel()
        label.text = "가격"
        return label
    }()
    private let nameKoLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let nameEnLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let descKoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    private let descEnLabel: UILabel = {
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
        nameKoLabel.text = product.nameKo ?? ""
        descKoLabel.text = product.descriptionKo ?? ""
        nameEnLabel.text = product.nameKo ?? ""
        descEnLabel.text = product.descriptionEn ?? ""
        priceLabel.text = "\(product.price ?? 0) 원"
        supplierLabel.text = product.supplier?.name ?? ""
    }
    
    private func setUI() {
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(nameKoTitle)
        stackView.addArrangedSubview(nameKoLabel)
        stackView.addArrangedSubview(nameEnTitle)
        stackView.addArrangedSubview(nameEnLabel)
        stackView.addArrangedSubview(descKoTitle)
        stackView.addArrangedSubview(descKoLabel)
        stackView.addArrangedSubview(descEnTitle)
        stackView.addArrangedSubview(descEnLabel)
        stackView.addArrangedSubview(priceTitle)

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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

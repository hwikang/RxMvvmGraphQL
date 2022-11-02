//
//  ProductListTableViewCell.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/10/30.
//

import Foundation
import UIKit

final class ProductListTableViewCell: UITableViewCell {

    private let idLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    private func setUI() {
        self.addSubview(idLabel)
        self.addSubview(nameLabel)
        self.addSubview(priceLabel)
        self.addSubview(supplierLabel)
        setConstraint()
    }
    
    private func setConstraint() {
        idLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(idLabel.snp.bottom)
        }
        priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(nameLabel.snp.bottom)
        }
        supplierLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(priceLabel.snp.bottom)
        }
        
    }
    
    public func configure(id: String, nameKo: String?, nameEn: String?, price: Int?, supplier: String?) {
        idLabel.text = "ID: \(id)"
        nameLabel.text = "\(nameKo ?? "") \(nameEn ?? "")"
        priceLabel.text = "\(price ?? 0) 원"
        supplierLabel.text = supplier
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

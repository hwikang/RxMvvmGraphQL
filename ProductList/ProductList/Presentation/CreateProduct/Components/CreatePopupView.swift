//
//  CreatePopupView.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/01.
//

import UIKit


final class CreatePopupView: UIView {
    
    public let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "이름"
        return label
    }()

    public let nameTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.text = "가격"
        return label
    }()
    
    public let priceTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let supplierLabel: UILabel = {
       let label = UILabel()
        label.text = "공급사"
        return label
    }()

    public let suppliersSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl()
        return control
    }()
    
    public let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("생성", for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    private func setUI() {
        self.addSubview(closeButton)
        self.addSubview(nameLabel)
        self.addSubview(nameTextField)
        self.addSubview(priceLabel)
        self.addSubview(priceTextField)
        self.addSubview(supplierLabel)
        self.addSubview(suppliersSegmentControl)
        self.addSubview(createButton)
        setConstraint()
    }
    
    private func setConstraint() {
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(nameTextField.snp.centerY)
            make.width.equalTo(40)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.equalTo(nameLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(priceTextField.snp.centerY)
            make.width.equalTo(40)

        }
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.leading.equalTo(priceLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        supplierLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(priceTextField.snp.bottom).offset(12)
        }
        suppliersSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(supplierLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        createButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

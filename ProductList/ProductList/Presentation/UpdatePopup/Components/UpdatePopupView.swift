//
//  UpdatePopupView.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/02.
//

import UIKit

final class UpdatePopupView: UIView {
    
    public let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let nameKoLabel: UILabel = {
       let label = UILabel()
        label.text = "한국어 상품명"
        return label
    }()
    private let nameEnLabel: UILabel = {
       let label = UILabel()
        label.text = "영어 상품명"
        return label
    }()
    private let descKoLabel: UILabel = {
       let label = UILabel()
        label.text = "한국어 상품 요약 설명"
        return label
    }()
    private let descEnLabel: UILabel = {
       let label = UILabel()
        label.text = "영어 상품 요약 설명"
        return label
    }()
    public let nameKoTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    public let nameEnTextField: UITextField = {
        let textField = UITextField()
         textField.borderStyle = .roundedRect
         return textField
    }()
    public let descKoTextView: UITextView = {
       let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray.cgColor
        return textView
    }()
    public let descEnTextView: UITextView = {
        let textView = UITextView()
         textView.layer.borderWidth = 1
         textView.layer.borderColor = UIColor.systemGray.cgColor
         return textView
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
        self.addSubview(nameKoLabel)
        self.addSubview(nameKoTextField)
        self.addSubview(nameEnLabel)
        self.addSubview(nameEnTextField)
        self.addSubview(descKoLabel)
        self.addSubview(descKoTextView)
        self.addSubview(descEnLabel)
        self.addSubview(descEnTextView)
        self.addSubview(priceLabel)
        self.addSubview(priceTextField)
        self.addSubview(createButton)
        setConstraint()
    }
    
    private func setConstraint() {
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
        }
        nameKoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(50)
        }
        nameKoTextField.snp.makeConstraints { make in
            make.top.equalTo(nameKoLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        nameEnLabel.snp.makeConstraints { make in
            make.top.equalTo(nameKoTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        nameEnTextField.snp.makeConstraints { make in
            make.top.equalTo(nameEnLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        descKoLabel.snp.makeConstraints { make in
            make.top.equalTo(nameEnTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        descKoTextView.snp.makeConstraints { make in
            make.top.equalTo(descKoLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(60)
        }
        descEnLabel.snp.makeConstraints { make in
            make.top.equalTo(descKoTextView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        descEnTextView.snp.makeConstraints { make in
            make.top.equalTo(descEnLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(60)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descEnTextView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
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

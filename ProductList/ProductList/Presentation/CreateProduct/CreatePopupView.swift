//
//  CreatePopupView.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/10/30.
//

import Foundation
import UIKit
import RxSwift

struct CreatePopupSize {
    static let deviceSize = UIScreen.main.bounds
    static let width = deviceSize.width * 0.8
    static let height = 400
}

final class CreatePopupView: UIView, UITextFieldDelegate {
    private let disposeBag = DisposeBag()
//    한국어 상품명, 가격, 공급사만 입력받아서 추가합니다.

    // MARK: - UI
    private let popup: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "가격"
        return label
    }()

    private let nameTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.text = "이름"
        return label
    }()

    private let priceTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private var currentTextField: UITextField?
    init() {
        super.init(frame: .zero)
        setUI()
        setEvent()
    }
    
    private func setEvent() {
        setDismissKeyboardEvent()
        closeButton.rx.tap.bind {[weak self] in
            self?.hide()
        }.disposed(by: disposeBag)
    }
    
    private func setDismissKeyboardEvent() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(gesture)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func show(parentView: UIView) {
        parentView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func hide() {
        self.removeFromSuperview()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CreatePopupView {
    private func setUI() {
        addSubview(popup)
        popup.addSubview(closeButton)
        popup.addSubview(nameLabel)
        popup.addSubview(nameTextField)
        popup.addSubview(priceLabel)
        popup.addSubview(priceTextField)
        self.backgroundColor = .black.withAlphaComponent(0.8)
        setConstraint()
    }
    
    private func setConstraint() {
       
        popup.snp.makeConstraints { make in
            make.width.equalTo(CreatePopupSize.width)
            make.height.equalTo(CreatePopupSize.height)
            make.center.equalToSuperview()
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(nameTextField.snp.centerY)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalTo(nameLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(priceTextField.snp.centerY)
        }
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.leading.equalTo(priceLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
}

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
    static let height = 300
}

final class CreatePopupView: UIView {
    private let disposeBag = DisposeBag()
    private let viewModel = CreatePopupViewModel(dataSource: ProductDataSourceImpl())
    
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
    
    private let supplierLabel: UILabel = {
       let label = UILabel()
        label.text = "공급사"
        return label
    }()

    private let suppliersSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl()
        return control
    }()
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("생성", for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    init() {
        super.init(frame: .zero)
        setUI()
        setEvent()
        bindViewModel()
        bindView()
        viewModel.fetchSupplier()
    }
    
    private func setEvent() {
        setDismissKeyboardEvent()
        closeButton.rx.tap.bind {[weak self] in
            self?.hide()
        }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = CreatePopupViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.supplierList
            .retry(3)
            .catchAndReturn([])
            .bind(onNext: {[weak self] itemList in
                guard let itemList = itemList else { return }
                for index in 0..<itemList.count {
                    self?.suppliersSegmentControl.insertSegment(withTitle: itemList[index].name, at: index, animated: true)
                }
                self?.suppliersSegmentControl.selectedSegmentIndex = 0
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindView() {
        createButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            if self.isValidText() {
            }
        }.disposed(by: disposeBag)
    }
    
    private func isValidText() -> Bool {
        if Validator.isEmpty(nameTextField.text) {
            print("Empty Name")
            return false
        }
        if Validator.isEmpty(priceTextField.text) {
            print("Empty Price")
            return false
        }
        return true
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CreatePopupView: UITextFieldDelegate {
    private func setUI() {
        addSubview(popup)
        popup.addSubview(closeButton)
        popup.addSubview(nameLabel)
        popup.addSubview(nameTextField)
        popup.addSubview(priceLabel)
        popup.addSubview(priceTextField)
        popup.addSubview(supplierLabel)
        popup.addSubview(suppliersSegmentControl)
        popup.addSubview(createButton)
        
        nameTextField.delegate = self
        priceTextField.delegate = self
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
            make.top.equalToSuperview().offset(50)
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
}


final class Validator {
    static func isEmpty(_ value: String?) -> Bool {
        if let value = value {
            return value.isEmpty
        }
        return true
    }
}

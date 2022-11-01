//
//  CreatePopupView.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/10/30.
//

import Foundation
import UIKit
import RxSwift

final class CreatePopupViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = CreatePopupViewModel(dataSource: ProductDataSourceImpl())
    
    private let popup: CreatePopupView = {
       let view = CreatePopupView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        setUI()
        setEvent()
        bindViewModel()
        bindView()
        viewModel.fetchSupplier()
    }
    
    private func setEvent() {
        setDismissKeyboardEvent()
        popup.closeButton.rx.tap.bind {[weak self] in
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
                    self?.popup.suppliersSegmentControl.insertSegment(withTitle: itemList[index].name, at: index, animated: true)
                }
                self?.popup.suppliersSegmentControl.selectedSegmentIndex = 0
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindView() {
        popup.createButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            if self.isValidText() {
                
            }
        }.disposed(by: disposeBag)
    }
    
    private func isValidText() -> Bool {
        if Validator.isEmpty(popup.nameTextField.text) {
            print("Empty Name")
            return false
        }
        if Validator.isEmpty(popup.priceTextField.text) {
            print("Empty Price")
            return false
        }
       
        return true
    }
    
    private func setDismissKeyboardEvent() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func hide() {
        self.dismiss(animated: true)
    }
    
}

extension CreatePopupViewController {
    private func setUI() {
        view.addSubview(popup)
        setConstraint()
    }
    
    private func setConstraint() {
        let deviceSize = UIScreen.main.bounds
        popup.snp.makeConstraints { make in
            make.width.equalTo(deviceSize.width * 0.8)
            make.height.equalTo(300)
            make.center.equalToSuperview()
        }
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

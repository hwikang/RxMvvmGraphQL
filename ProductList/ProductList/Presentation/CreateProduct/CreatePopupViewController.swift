//
//  CreatePopupView.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/10/30.
//

import UIKit
import RxSwift
import RxRelay
import Apollo
protocol CreatePopupDeleate {
    func onCreateDone()
}

final class CreatePopupViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = CreatePopupViewModel(dataSource: ProductDataSourceImpl())
    private let createProductInput = PublishSubject<CreateProductInput>()
    private var supplierList: [SupplierListQuery.Data.SupplierList.ItemList]?
    public var delegate: CreatePopupDeleate?
    
    private let popup: CreatePopupView = {
       let view = CreatePopupView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        setUI()
        bindViewModel()
        bindView()
        setDismissKeyboardEvent()
    }
    
    private func bindViewModel() {
        let input = CreatePopupViewModel.Input(createInput: createProductInput.asObservable())
        let output = viewModel.transform(input: input)
        
        output.supplierList
            .catch { error in
                if let error = error as? GraphQLError {
                    print("GraphQLError \(error.localizedDescription)")
                    
                } else {
                    print("NetworkError \(error.localizedDescription)")
                }
                return Observable.just([])
            }
            .bind(onNext: {[weak self] itemList in
                guard let itemList = itemList else { return }
                self?.supplierList = itemList
                for index in 0..<itemList.count {
                    self?.popup.suppliersSegmentControl.insertSegment(withTitle: itemList[index].name, at: index, animated: true)
                }
                self?.popup.suppliersSegmentControl.selectedSegmentIndex = 0
            })
            .disposed(by: disposeBag)
        
        output.createDone
            .catch { error in
                if error is GraphQLError {
                    print("GraphQLError \(error.localizedDescription)")
                } else {
                    print("NetworkError \(error.localizedDescription)")
                }
                return Observable.just(false)
            }
            .bind(onNext: {[weak self] isDone in
            if isDone {
                self?.delegate?.onCreateDone()
                self?.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindView() {
        popup.createButton.rx.tap.bind { [weak self] in
            guard let self = self,
                  let priceText = self.popup.priceTextField.text,
                  let nameText = self.popup.nameTextField.text else { return }
            
            if !self.isValidText(priceText: priceText, nameText: nameText) { return }
            
            guard let price = Int(priceText) else { return }
            
            let selectedSupplierIndex = self.popup.suppliersSegmentControl.selectedSegmentIndex
            guard let supplierId = self.getSupplierIdByIndex(selectedSupplierIndex) else { return }

            let input = CreateProductInput(supplierId: supplierId, nameKo: nameText, price: price)
            self.createProductInput.onNext(input)
            
        }.disposed(by: disposeBag)
        
        popup.closeButton.rx.tap.bind {[weak self] in
            self?.hide()
        }.disposed(by: disposeBag)
    }
    
    private func isValidText(priceText: String, nameText: String) -> Bool {
        if Validator.isEmpty(nameText) {
            print("Empty Name")
            return false
        }
        if Validator.isEmpty(priceText) {
            print("Empty Price")
            return false
        }
       
        return true
    }
    
    func getSupplierIdByIndex(_ index: Int) -> String? {
        return supplierList?[index].id
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

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

final class CreatePopupViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = CreatePopupViewModel(dataSource: ProductDataSourceImpl())
    private let createProductInput = PublishSubject<CreateProductInput>()
    private var supplierList: [SupplierListQuery.Data.SupplierList.ItemList]?
    public weak var delegate: ProductListDelegate?
    
    private let popup: CreatePopupView = {
       let view = CreatePopupView()
        view.backgroundColor = .white
        return view
    }()
    private var loadingView: UIActivityIndicatorView?

    override func viewDidLoad() {
        setUI()
        bindViewModel()
        bindView()
        bindNotification()
        setDismissKeyboardEvent()
        loadingView = LoadingIndicator.showLoading(parentView: self.view)

    }
    
    private func bindViewModel() {
        let input = CreatePopupViewModel.Input(createInput: createProductInput.asObservable())
        let output = viewModel.transform(input: input)
        
        output.supplierList
            .catch {[weak self] error in
                self?.present(Dialog.getDialog(title: "에러", message: error.localizedDescription), animated: true)
                return Observable.just([])
            }
            .bind(onNext: {[weak self] itemList in
                guard let itemList = itemList else { return }
                self?.supplierList = itemList
                DispatchQueue.main.async {
                    for index in 0..<itemList.count {
                        self?.popup.suppliersSegmentControl.insertSegment(withTitle: itemList[index].name, at: index, animated: true)
                    }
                    self?.popup.suppliersSegmentControl.selectedSegmentIndex = 0
                    self?.loadingView?.removeFromSuperview()
                }
                
            })
            .disposed(by: disposeBag)
        
        output.createDone
            .catch {[weak self] error in
                self?.present(Dialog.getDialog(title: "에러", message: error.localizedDescription), animated: true)
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
    
    private func bindNotification() {
        let keyboardObservable = Observable.merge([
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).map({ _ in return true }),
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).map({ _ in return false})])
        keyboardObservable.bind {[weak self] isShowKeyboard in
            guard let self = self else {return }
            if isShowKeyboard {
                self.popup.center = CGPoint(x: self.view.center.x, y: 200 )
            } else {
                self.popup.center = CGPoint(x: self.view.center.x, y: self.view.center.y)

            }
        }.disposed(by: disposeBag)
    }
    
    private func isValidText(priceText: String, nameText: String) -> Bool {
        if Validator.isEmpty(nameText) {
            self.present(Dialog.getDialog(title: "입력", message: "이름을 입력해주세요."), animated: true)
            return false
        }
        if Validator.isEmpty(priceText) {
            self.present(Dialog.getDialog(title: "입력", message: "가격을 입력해주세요."), animated: true)
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

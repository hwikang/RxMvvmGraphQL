//
//  UpdateProduct.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/02.
//


import UIKit
import RxSwift
import RxRelay
import Apollo

final class UpdatePopupViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = UpdatePopupViewModel(dataSource: ProductDataSourceImpl())
    
    private let popup: UpdatePopupView = {
       let view = UpdatePopupView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        setUI()
        bindViewModel()
        bindView()
        bindNotification()
        setDismissKeyboardEvent()
    }
    
    private func bindViewModel() {
        let input = UpdatePopupViewModel.Input()
        let output = viewModel.transform(input: input)
        
    }
    
    private func bindView() {
        
           
    }
    
    private func bindNotification() {
        let keyboardObservable = Observable.merge([
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).map({ _ in return true }),
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).map({ _ in return false})])
        keyboardObservable.bind {[weak self] isShowKeyboard in
            guard let self = self else {return }
            if isShowKeyboard {
                self.remakePupupConstraint(yOffset: -100)
            } else {
                self.remakePupupConstraint(yOffset: 0)

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

extension UpdatePopupViewController {
    private func setUI() {
        self.view.addSubview(popup)
        setConstraint()
    }
    
    private func setConstraint() {
        let deviceSize = UIScreen.main.bounds
        popup.snp.makeConstraints { make in
            make.width.equalTo(deviceSize.width * 0.8)
            make.height.equalTo(550)
            make.centerX.equalToSuperview()
            make.top.equalTo(40)
        }
    }
    private func remakePupupConstraint(yOffset: Int) {
        let deviceSize = UIScreen.main.bounds
        self.popup.snp.remakeConstraints { make in
            make.width.equalTo(deviceSize.width * 0.8)
            make.height.equalTo(550)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(yOffset)
        }
        UIView.animate(withDuration: 1, delay: .zero, options: .curveEaseIn) {[weak self] in
            self?.view.layoutSubviews()
        }
    }
}

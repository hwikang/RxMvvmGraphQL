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
    private let updateProductInput = PublishSubject<UpdateProductInput>()
    public weak var delegate: ProductDetailDelegate?
    
    private let popup: UpdatePopupView = {
       let view = UpdatePopupView()
        view.backgroundColor = .white
        return view
    }()
    private let productId: String
    init(productId: String) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        setUI()
        bindViewModel()
        bindView()
        bindNotification()
        setDismissKeyboardEvent()
    }
    
    private func bindViewModel() {
        let input = UpdatePopupViewModel.Input(updateInput: updateProductInput.asObservable())
        let output = viewModel.transform(input: input)
        output.updateDone
            .catch {[weak self] error in
                self?.present(Dialog.getDialog(title: "에러", message: error.localizedDescription), animated: true)
                return Observable.just(UpdateProductMutation.Data.UpdateProduct())
            }
            .bind(onNext: {[weak self] product in
                print(product)
                let dialog = Dialog.getDialog(title: "수정", message: "상품 정보가 수정되었습니다.") {
                    self?.delegate?.onUpdateDone()
                    self?.dismiss(animated: true)
                }
                self?.present(dialog, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func bindView() {
        popup.createButton.rx.tap.bind { [weak self] in
            guard let self = self,
                  let priceText = self.popup.priceTextField.text,
                  let nameKoText = self.popup.nameKoTextField.text,
                    let nameEnText = self.popup.nameEnTextField.text,
                    let descKoText = self.popup.descKoTextView.text,
                    let descEnText = self.popup.descEnTextView.text else { return }
            
            if !self.isValidText(priceText: priceText, nameKoText: nameKoText, nameEnText: nameEnText, descKoText: descKoText, descEnText: descEnText) { return }
            guard let price = Int(priceText) else { return }

            let input = UpdateProductInput(id: self.productId, nameKo: nameKoText, nameEn: nameEnText, descriptionKo: descKoText, descriptionEn: descEnText, price: price)
            self.updateProductInput.onNext(input)
        }.disposed(by: disposeBag)
           
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
    
    private func isValidText(priceText: String, nameKoText: String, nameEnText: String, descKoText: String, descEnText: String) -> Bool {
        if Validator.isEmpty(nameKoText) {
            self.present(Dialog.getDialog(title: "입력", message: "한국어 이름을 입력해주세요."), animated: true)
            return false
        }
        if Validator.isEmpty(nameEnText) {
            self.present(Dialog.getDialog(title: "입력", message: "영어 이름을 입력해주세요."), animated: true)
            return false
        }
        if Validator.isEmpty(descKoText) {
            self.present(Dialog.getDialog(title: "입력", message: "한국어 상품 요약 설명을 입력해주세요."), animated: true)
            return false
        }
        if Validator.isEmpty(descEnText) {
            self.present(Dialog.getDialog(title: "입력", message: "영어 상품 요약 설명을 입력해주세요."), animated: true)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

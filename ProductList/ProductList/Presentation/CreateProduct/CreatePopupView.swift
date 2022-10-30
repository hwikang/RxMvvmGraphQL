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

final class CreatePopupView: UIView {
    private let disposeBag = DisposeBag()
//    한국어 상품명, 가격, 공급사만 입력받아서 추가합니다.

    // MARK: - UI
    public let popup: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    public let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    public let nameTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = .red
        return textField
    }()
    
    
    init() {
        super.init(frame: .zero)
        setUI()
        setEvent()
    }
    
    private func setUI() {
        addSubview(popup)
        popup.addSubview(closeButton)
        popup.addSubview(nameTextField)
        self.backgroundColor = .black.withAlphaComponent(0.8)

        setConstraint()
    }
    
    private func setEvent() {
        closeButton.rx.tap.bind {[weak self] in
            self?.hide()
        }.disposed(by: disposeBag)
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
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func show() {
        guard let firstWindow = UIApplication.shared.windows.first else {
            return
        }
        
        let parentView = firstWindow.rootViewController?.view
        
        parentView?.addSubview(self)
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

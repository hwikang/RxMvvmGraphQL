//
//  CreatePopupView.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/10/30.
//

import Foundation
import UIKit

struct CreatePopupSize {
    static let deviceSize = UIScreen.main.bounds
    static let width = deviceSize.width * 0.8
    static let height = 400
}

final class CreatePopupView: UIView {
    
    public let popup: UIView = {
       let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setUI()
    }
    
    private func setUI() {
        addSubview(popup)
        self.backgroundColor = .black.withAlphaComponent(0.8)

        setConstraint()
    }
    
    private func setConstraint() {
       
        popup.snp.makeConstraints { make in
            make.width.equalTo(CreatePopupSize.width)
            make.height.equalTo(CreatePopupSize.height)
            make.center.equalToSuperview()
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

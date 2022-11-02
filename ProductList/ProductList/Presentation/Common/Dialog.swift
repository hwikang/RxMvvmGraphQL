//
//  BasicPopupView.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/01.
//

import UIKit

final class Dialog {
    static func getDialog(title: String, message: String, handler: @escaping () -> Void = {}) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionConfirm = UIAlertAction(title: "확인", style: .cancel) { _ in
            handler()
        }
        alert.addAction(actionConfirm)
        return alert
    }
    
    static func getQuestionDialog(title: String, message: String, handler: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "예", style: .default) { _ in
            handler()
        }
        
        alert.addAction(actionYes)
        alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
        return alert
    }
}

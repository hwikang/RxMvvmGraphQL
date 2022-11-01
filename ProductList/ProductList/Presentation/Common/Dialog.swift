//
//  BasicPopupView.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/01.
//

import UIKit

final class Dialog {
    static func getDialog(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        return alert
    }
}

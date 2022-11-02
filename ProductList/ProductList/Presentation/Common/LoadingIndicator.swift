//
//  LoadingIndicator.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/02.
//

import UIKit
class LoadingIndicator {
    static func showLoading(parentView: UIView) -> UIActivityIndicatorView {
        let loadingIndicatorView = UIActivityIndicatorView(style: .large)
        parentView.addSubview(loadingIndicatorView)
        
        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(parentView.snp.center)
        }
        DispatchQueue.main.async {
            loadingIndicatorView.startAnimating()
        }
        return loadingIndicatorView
    }
//    
//    static func hideLoading() {
//        DispatchQueue.main.async {
//        }
//    }
}

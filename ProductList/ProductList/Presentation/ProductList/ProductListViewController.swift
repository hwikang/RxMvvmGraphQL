//
//  ViewController.swift
//  ProductList
//
//  Created by Simon on 2022/10/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProductListViewController: UIViewController, UITableViewDelegate, ProductListDelegate {
   
    private let disposeBag = DisposeBag()
    private let viewModel = ProductListViewModel(dataSource: ProductDataSourceImpl())
    private let needUpdateList = PublishSubject<Bool>()
    
    private lazy var productListTableView: UITableView = {
        let tableView = UITableView()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: "ProductListCell")
        tableView.rowHeight = 100
        return tableView
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("생성", for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    private var loadingView: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        bindViewModel()
        bindView()
        loadingView = LoadingIndicator.showLoading(parentView: self.view)
    }
    
    private func bindViewModel() {
        let input = ProductListViewModel.Input(needUpdateList: needUpdateList.asObservable())
        let output = viewModel.transform(input: input)
        
        output.productList
            
            .catch({ error in
                self.present(Dialog.getDialog(title: "에러", message: error.localizedDescription), animated: true)
                return Observable.just([])
            })
            .bind(to: productListTableView.rx.items(cellIdentifier: "ProductListCell", cellType: ProductListTableViewCell.self)) {[weak self] (_, element, cell) in
                cell.configure(id: element.id, nameKo: element.nameKo, nameEn: element.nameEn, price: element.price, supplier: element.supplier?.name)
                self?.loadingView?.removeFromSuperview()
            }
            
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        createButton.rx.tap.bind {[weak self] in
            
            let popupVC = CreatePopupViewController()
            popupVC.delegate = self
            self?.present(popupVC, animated: true)
        }.disposed(by: disposeBag)
        
        productListTableView.rx.modelSelected(ProductListQuery.Data.ProductList.ItemList.self).bind {[weak self] product in
            let id = product.id
            let productVC = ProductViewController(productId: id)
            productVC.delegate = self
            self?.navigationController?.pushViewController(productVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    func updateList() {
        needUpdateList.onNext(true)
    }
}

extension ProductListViewController {
    
    private func setUI() {
        self.view.addSubview(productListTableView)
        self.view.addSubview(createButton)
        setConstraint()
    }
    
    private func setConstraint() {
        productListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        createButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.width.height.equalTo(60)
        }
    }
}

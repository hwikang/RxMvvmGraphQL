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

final class ProductListViewController: UIViewController, UITableViewDelegate {
   
    // MARK: - Property
    private let disposeBag = DisposeBag()
    private let viewModel = ProductListViewModel(dataSource: ProductDataSourceImpl())
    // MARK: - UI
    lazy var productListTableView: UITableView = {
        let tableView = UITableView()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(ProductListTableViewCell.self, forCellReuseIdentifier: "ProductListCell")
        tableView.rowHeight = 100
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        setUI()
        bindViewModel()
        viewModel.fetchProductList()
    }
    
    func bindViewModel() {
        let input = ProductListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.productList
            .retry(3)
            .bind(to: productListTableView.rx.items(cellIdentifier: "ProductListCell", cellType: ProductListTableViewCell.self)) { (_, element, cell) in
                print("element \(element)")
                cell.configure(id: element.id, nameKo: element.nameKo, nameEn: element.nameEn, price: element.price, supplier: element.supplier?.name)
            }
            .disposed(by: disposeBag)
    }
}

extension ProductListViewController {
    func setUI() {
        self.view.addSubview(productListTableView)
        setConstraint()
    }
    
    func setConstraint() {
        productListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

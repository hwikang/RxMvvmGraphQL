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
    
    lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("생성", for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        setUI()
        bindViewModel()
        bindView()
        viewModel.fetchProductList()
    }
    
    func bindViewModel() {
        let input = ProductListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.productList
            .retry(3)
            .catchAndReturn([])
            .bind(to: productListTableView.rx.items(cellIdentifier: "ProductListCell", cellType: ProductListTableViewCell.self)) { (_, element, cell) in
                cell.configure(id: element.id, nameKo: element.nameKo, nameEn: element.nameEn, price: element.price, supplier: element.supplier?.name)
            }
            
            .disposed(by: disposeBag)
    }
    
    func bindView() {
        createButton.rx.tap.bind {
            let popupView = CreatePopupView()
            popupView.show(parentView: self.view)
        }.disposed(by: disposeBag)
    }
}

extension ProductListViewController {
    func setUI() {
        self.view.addSubview(productListTableView)
        self.view.addSubview(createButton)
        setConstraint()
    }
    
    func setConstraint() {
        productListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        createButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(60)
        }
    }
}

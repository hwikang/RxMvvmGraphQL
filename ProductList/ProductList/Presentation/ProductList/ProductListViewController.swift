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
import Apollo

final class ProductListViewController: UIViewController, UITableViewDelegate {
   
    private let disposeBag = DisposeBag()
    private let viewModel = ProductListViewModel(dataSource: ProductDataSourceImpl())
    private let needUpdateList = PublishSubject<Bool>()
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
        
        setUI()
        bindViewModel()
        bindView()
    }
    
    func bindViewModel() {
        let input = ProductListViewModel.Input(needUpdateList: needUpdateList.asObservable())
        let output = viewModel.transform(input: input)
        
        output.productList
            .retry(3)
            .catch({ error in
                if error is GraphQLError {
                    print("GraphQLError \(error.localizedDescription)")
                } else{
                    print("NetworkError \(error.localizedDescription)")
                }
                return Observable.just([])
            })
            .bind(to: productListTableView.rx.items(cellIdentifier: "ProductListCell", cellType: ProductListTableViewCell.self)) { (_, element, cell) in
                cell.configure(id: element.id, nameKo: element.nameKo, nameEn: element.nameEn, price: element.price, supplier: element.supplier?.name)
            }
            
            .disposed(by: disposeBag)
    }
    
    func bindView() {
        createButton.rx.tap.bind {
            let popupVC = CreatePopupViewController()
            popupVC.delegate = self
            self.present(popupVC, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension ProductListViewController: CreatePopupDeleate {
    
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
    
    func onCreateDone() {
        needUpdateList.onNext(true)
    }

}

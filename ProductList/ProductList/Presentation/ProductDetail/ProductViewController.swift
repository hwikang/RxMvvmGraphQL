//
//  ProductDetailViewController.swift
//  ProductList
//
//  Created by 슈퍼 on 2022/11/01.
//

import UIKit
import RxSwift

final class ProductViewController: UIViewController, ProductDetailDelegate {
    private let disposeBag = DisposeBag()
    private lazy var viewModel = ProductViewModel(id: self.productId, dataSource: ProductDataSourceImpl())
    private let deleteProduct = PublishSubject<Bool>()
    private let needUpdateProduct = PublishSubject<Bool>()
    private let productId: String
    public weak var delegate: ProductListDelegate?

    private let productView: ProductDetailView = {
       let view = ProductDetailView()
        return view
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.backgroundColor = .systemRed
        return button
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.backgroundColor = .systemCyan
        return button
    }()
    
    init(productId: String) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
   
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setUI()
        bindView()
        bindViewModel()
    }
    
    private func bindView() {
        deleteButton.rx.tap.bind { [weak self] in
            let dialog = Dialog.getQuestionDialog(title: "삭제", message: "상품을 삭제 하시겠습니까?") {[weak self] in
                self?.deleteProduct.onNext(true)
            }
            self?.present(dialog, animated: true)
        }.disposed(by: disposeBag)
        
        editButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let updateVC = UpdatePopupViewController(productId: self.productId)
            updateVC.delegate = self
            self.present(updateVC, animated: true)
        }.disposed(by: disposeBag)
    }
    private func bindViewModel() {
        let input = ProductViewModel.Input(deleteProduct: deleteProduct.asObservable(), needUpdateProduct: needUpdateProduct.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.productDetail
            .catch { [weak self] error in
                self?.present(Dialog.getDialog(title: "에러", message: error.localizedDescription), animated: true)
                return Observable.just(ProductQuery.Data.Product())
            }
            .bind {[weak self] product in
                DispatchQueue.main.async {
                    self?.productView.setLabelText(product: product)
                }
            
        }.disposed(by: disposeBag)
        
        output.deleteDone
            .catch { [weak self] error in
            self?.present(Dialog.getDialog(title: "에러", message: error.localizedDescription), animated: true)
            return Observable.just(false)
            }.bind { [weak self] deleteDone in
                if deleteDone {
                    let dialog = Dialog.getDialog(title: "삭제", message: "상품이 삭제 되었습니다.", handler: {
                        self?.delegate?.onDeleteDone()
                        self?.navigationController?.popViewController(animated: true)
                    })
                    self?.present(dialog, animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    func onUpdateDone() {
        self.needUpdateProduct.onNext(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductViewController {
    private func setUI() {
        self.view.addSubview(productView)
        self.view.addSubview(deleteButton)
        self.view.addSubview(editButton)
        setConstraint()
    }
    private func setConstraint() {
        productView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.width.height.equalTo(60)
        }
        editButton.snp.makeConstraints { make in
            make.trailing.equalTo(deleteButton.snp.leading).offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.width.height.equalTo(60)
        }
    }
}

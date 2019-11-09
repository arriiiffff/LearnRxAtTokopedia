//
//  ProductViewController.swift
//  TokopediaRxExample
//
//  Created by GITS on 09/11/19.
//  Copyright © 2019 Muhammad Arif. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProductViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var pmin = "10000"
    var pmax = "10000000"
    var wholeSale = "true"
    var official = "true"
    var fshop = "2"
    let refreshControl = UIRefreshControl()
    
    private let viewModel = ReactiveProductListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupViewModel(pmin: self.pmin, pmax: self.pmax, wholeSale: self.wholeSale, official: self.official, fshop:self.fshop)
    }
    
    private func setupView() {
        self.collectionView.refreshControl = refreshControl
        self.collectionView.register(UINib(nibName: "ProductListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductCollectionCell")
        
    }
    
    private func setupViewModel(pmin: String, pmax: String, wholeSale: String, official: String, fshop:String) {
        // MARK: Input
        let input = ReactiveProductListViewModel.Input(didLoadTrigger: .just(()), didTapCellTrigger: self.collectionView.rx.itemSelected.asDriver(), pullToRefreshTrigger: refreshControl.rx.controlEvent(.allEvents).asDriver())
        
        let output = viewModel.transform(pmin: pmin, pmax: pmax, wholeSale: wholeSale, official: official, fshop: fshop, input: input)
        
        output.productListCellData
            .drive(self.collectionView.rx.items(cellIdentifier: "ProductCollectionCell", cellType: ProductListCollectionViewCell.self)) {
                row, model, cell in
                cell.configureCell(with: model)
        }.disposed(by: disposeBag)
        
        output.errorData
            .drive(onNext: { errorMessage in
                print("error")
            }).disposed(by: disposeBag)
        
        output.selectedIndex.drive(onNext: { (index, model) in
            print("ini index \(index), model: \(model)")
        }).disposed(by: disposeBag)
        
        output
            .isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    @IBAction func btnFilter(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Filter", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "FilterVC") as? FilterViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension ProductViewController: FilterDelegate {
    
    func applyChanges(pmin: String, pmax: String, wholeSale: String, official: String, fshop:String) {
        self.collectionView.dataSource = self as? UICollectionViewDataSource
        self.setupViewModel(pmin: pmin, pmax: pmax, wholeSale: wholeSale, official: official, fshop: fshop)
    }
    
}

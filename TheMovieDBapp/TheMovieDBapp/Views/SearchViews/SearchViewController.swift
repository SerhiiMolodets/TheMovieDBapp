//
//  SearchViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 07.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    @IBOutlet weak var serachTableView: UITableView! {
        didSet {
            serachTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCellId")
        }
    }
    
    @IBOutlet weak var searchField: UISearchBar!
    let searchVm = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    var errorView: UIView? {
        return nil
    }
    
    var loadingView: UIView? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToSearchVM()
        setupObservers()
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 0.023, green: 0.011, blue: 0.171, alpha: 0.5)
        errorView?.isHidden = true
        loadingView?.isHidden = true
    }
    
    private func bindToSearchVM() {
        
        //binding entry search to searchVm
        searchField
            .rx
            .text
            .orEmpty
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: searchVm.searchObserver)
            .disposed(by: disposeBag)
        
        searchVm.isLoading.asDriver().drive(serachTableView.rx.isHidden).disposed(by: disposeBag)
        
        searchVm.error
            .map { $0 != nil }
            .drive(serachTableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        if let loadingView = loadingView {
            searchVm.isLoading
                .map(!)
                .drive(loadingView.rx.isHidden)
                .disposed(by: disposeBag)
            searchVm.error
                .map { $0 != nil }
                .drive(loadingView.rx.isHidden)
                .disposed(by: disposeBag)
        }
        if let errorView = errorView {
                searchVm.error
                    .map { $0 == nil }
                    .drive(errorView.rx.isHidden)
                    .disposed(by: disposeBag)
            }
    }
    
    func setupObservers() {
        searchVm.content
            .drive(serachTableView.rx.items(cellIdentifier: "SearchCellId", cellType: SearchTableViewCell.self)) {_, movie, cell in
                cell.configure(with: movie)
                
            }.disposed(by: disposeBag)
    
}
}

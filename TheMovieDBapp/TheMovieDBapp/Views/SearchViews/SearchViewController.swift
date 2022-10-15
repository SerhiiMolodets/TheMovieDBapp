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
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            // MARK: - Register cell
            searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCellId")
            searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "historyCellId")
        }
    }
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var searchField: UISearchBar!
    let searchVm = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    var errorView: UIView? {
        errorLabel.text = "Not found"
        return errorLabel
    }
    
    var loadingView: UIView? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToSearchVM()
        setupObservers()
        setupUI()
        selected()
    }
    // MARK: - Bind to search viewModel
    private func bindToSearchVM() {
        // binding entry search to searchVm
        searchField
            .rx
            .text
            .orEmpty
        
            .distinctUntilChanged()
            .bind(to: searchVm.searchObserver)
            .disposed(by: disposeBag)
        
        searchVm.isLoading.asDriver().drive(searchTableView.rx.isHidden).disposed(by: disposeBag)
        
        searchVm.error
            .map { $0 != nil }
            .drive(searchTableView.rx.isHidden)
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
    // MARK: - Observe data from search viewModel
    private func setupObservers() {
        searchVm.content
            .drive(searchTableView.rx.items(cellIdentifier: "SearchCellId", cellType: SearchTableViewCell.self)) {_, movie, cell in
                cell.configure(with: movie)
            }.disposed(by: disposeBag)
    }
    // MARK: - Configure UI
    private func setupUI() {
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 0.023, green: 0.011, blue: 0.171, alpha: 0.5)
        errorView?.isHidden = true
        loadingView?.isHidden = true
        searchTableView.backgroundColor = UIColor(displayP3Red: 0.023, green: 0.011, blue: 0.171, alpha: 1)
        
    }
    // MARK: - Push to detail screen
    private func selected() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        searchTableView.rx.modelSelected(Media.self)
            .subscribe { movie in
                if let detailViewController = storyboard.instantiateViewController(identifier: "MoviewDetailViewControllerId")
                    as? MoviewDetailViewController {
                    detailViewController.movieDetailViewModel = MoviewDetailViewModel(movie: movie.element!)
                    self.navigationController?.pushViewController(detailViewController, animated: true)
                }
            }.disposed(by: disposeBag)
    }
}

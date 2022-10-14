//
//  FavoriteViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 14.10.2022.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController {
    let favoritesViewModel = FavoritesViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var favoritesTableView: UITableView! {
        didSet {
            favoritesTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteCellId")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToVM()
        setupObservers()
        setupUI()
    }
    
    private func bindToVM() {
        typeSegmentControl
            .rx
            .selectedSegmentIndex
            .values
            .asObservable().subscribe { [weak self] segment in
                switch segment.element {
                case 0: self?.favoritesViewModel.mediaType = .movies
                    self?.favoritesViewModel.getList()
                case 1: self?.favoritesViewModel.mediaType = .tv
                    self?.favoritesViewModel.getList()
                default: break
                }
            }.disposed(by: disposeBag)
    }
    
    private func setupObservers() {
        favoritesViewModel.getList()
        favoritesViewModel.content
            .drive(favoritesTableView.rx.items(cellIdentifier: "FavoriteCellId", cellType: FavoriteTableViewCell.self)) {_, media, cell in
                cell.configure(media)
                
            }.disposed(by: disposeBag)
    }
    
    private func setupUI() {
        favoritesTableView.backgroundColor = UIColor(displayP3Red: 0.023, green: 0.011, blue: 0.171, alpha: 1)
        typeSegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        typeSegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
}

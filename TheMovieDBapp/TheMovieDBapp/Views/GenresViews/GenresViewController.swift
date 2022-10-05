//
//  GenresViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import UIKit
import RxSwift
import RxCocoa

class GenresViewController: UIViewController {
    let genresViewModel = GenresViewModel()
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    @IBOutlet weak var genreTableView: UITableView! {
        didSet {
            genreTableView.register(UINib(nibName: "GenreTableViewCell", bundle: nil), forCellReuseIdentifier: "GenreViewCellId")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindTableData()
    
    }
    
    // MARK: Connetct data and configure tableView
    func bindTableData() {
        //        Drive genres to table
        self.genresViewModel.sourceDataTableView.switchLatest().asDriver(onErrorJustReturn: [])
            .drive(self.genreTableView.rx.items(cellIdentifier: "GenreViewCellId",
                                           cellType: GenreTableViewCell.self)) {[weak self] _, genre, cell in
                guard let self = self else { return }
                cell.configure(genre, state: self.typeSegmentControl.selectedSegmentIndex)
            }.disposed(by: self.disposeBag)
        //        Update genres
        self.genresViewModel.updateMovieGenres()
        
        typeSegmentControl.rx.value.asDriver().drive { [weak self] state in
            guard let self = self else { return }
            switch state {
            case 0:
                self.genresViewModel.updateMovieGenres()
            case 1:
                self.genresViewModel.updateTVGenres()
            default:
                fatalError("segment controll error")
            }
        
        }.disposed(by: disposeBag)

    }
    
}

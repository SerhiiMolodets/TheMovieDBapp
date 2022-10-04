//
//  GenresViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import UIKit
import RxSwift

class GenresViewController: UIViewController {
    let genresViewModel = GenresViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var genreTableView: UITableView! {
        didSet {
            genreTableView.register(UINib(nibName: "GenreTableViewCell", bundle: nil), forCellReuseIdentifier: "GenreViewCellId")
        }
    }
    @IBOutlet weak var typeSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableData()
    }
    
    // MARK: Connetct data and configure tableView
    func bindTableData() {
        //        Drive genres to table
        genresViewModel.genres.asDriver(onErrorJustReturn: [])
            .drive(genreTableView.rx.items(cellIdentifier: "GenreViewCellId",
                                           cellType: GenreTableViewCell.self)) {_, genre, cell in
                cell.configure(genre)
            }.disposed(by: disposeBag)
        //        Update genres
        genresViewModel.updateGenre()
        //        Bind a model selected handler
        //        genreTableView.rx.modelSelected(Genre.self).bind { genre in
        //            print(genre.name)
        //        }.disposed(by: disposeBag)
        
    }
}

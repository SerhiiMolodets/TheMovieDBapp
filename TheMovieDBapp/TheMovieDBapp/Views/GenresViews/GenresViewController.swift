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

        bindMoviesTableData()
//        typeSegmentControl.rx.value.bind(to: genresViewModel.movieOrTV).disposed(by: disposeBag)??????
    
    }
    
    // MARK: Connetct data and configure tableView
    func bindMoviesTableData() {
        //        Drive genres to table
        self.genresViewModel.sourceDataTableView.switchLatest().asDriver(onErrorJustReturn: [])
            .drive(self.genreTableView.rx.items(cellIdentifier: "GenreViewCellId",
                                           cellType: GenreTableViewCell.self)) {_, genre, cell in
                cell.configure(genre)
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

        //        Bind a model selected handler
        //        genreTableView.rx.modelSelected(Genre.self).bind { genre in
        //            print(genre.name)
        //        }.disposed(by: disposeBag)
        
    }
    @IBAction func segmentControChanged(_ sender: Any) {
     
    }
    
}

//
//  GenreTableViewCell.swift
//  TheMovieDBapp
//  Created by Сергей Молодец on 29.09.2022.
//

import UIKit
import RxSwift
import RxCocoa

class GenreTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    let genresViewModel = GenresViewModel()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView! {
        didSet {
            // MARK: - Register cell
            genreCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil),
                                         forCellWithReuseIdentifier: "GenreCollectionViewCellId")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupObservers()
        selected()
    }
    // MARK: - Observe dataSource from genres viewModel
    private func setupObservers() {
        genresViewModel.dataCollectionView
            .asDriver()
            .drive(genreCollectionView
                .rx
                .items(dataSource: genresViewModel.dataSource))
            .disposed(by: disposeBag)
    }
    // MARK: - Configure cell in depends from movie or TV
    func configure(_ genre: Genre, state segment: Int) {
        self.titleLabel.text = genre.name
        
        switch segment {
        case 0:
            genresViewModel.getMovieWith(genre: genre.id)
        case 1:
            genresViewModel.getTVsWith(genre: genre.id)
        default:
            fatalError("segment controll error")
        }
    }
    // MARK: - Push to detail screen
    private func selected() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // send data to next screen
        genreCollectionView.rx.modelSelected(Media.self)
            .subscribe { movie in
                if let detailViewController = storyboard.instantiateViewController(identifier: "MoviewDetailViewControllerId")
                    as? MoviewDetailViewController {
                    detailViewController.movieDetailViewModel = MoviewDetailViewModel(movie: movie.element!)
                    self.parentViewController?.navigationController?.pushViewController(detailViewController, animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
}

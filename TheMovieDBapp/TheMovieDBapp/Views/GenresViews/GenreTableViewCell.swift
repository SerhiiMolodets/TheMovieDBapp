//
//  GenreTableViewCell.swift
//  TheMovieDBapp
//
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
            genreCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil),
                                         forCellWithReuseIdentifier: "GenreCollectionViewCellId")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindToCollectionViewData()
        genreCollectionView.rx.modelSelected(ResultByGenre.self)
            .subscribe {print($0.element!.id) }.disposed(by: disposeBag)
       
    }
    
        private func bindToCollectionViewData() {
            genresViewModel.dataCollectionView
                .asDriver()
                .drive(genreCollectionView
                    .rx
                    .items(dataSource: genresViewModel.dataSource))
                .disposed(by: disposeBag)
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
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
    
}

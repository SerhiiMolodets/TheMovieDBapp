//
//  GenreTableViewCell.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import UIKit
import RxSwift

class GenreTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    let genresViewModel = GenresViewModel()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView! {
        didSet {
            genreCollectionView.register(UINib(nibName: "GenreCollectionViewCell", bundle: nil),
                                         forCellWithReuseIdentifier: "GenreCollectionViewCellId")
            genreCollectionView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.genresViewModel.movieOrTV.asObservable().subscribe { event in
        //            print(event)
        //        }.disposed(by: disposeBag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func configure(_ genre: Genre) {
        self.titleLabel.text = genre.name
        self.genresViewModel.getMovieWith(genre: genre.id) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.genreCollectionView.reloadData()
            }
        }
    }
    
}

extension GenreTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genresViewModel.moviesByGenre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCellId", for: indexPath) as! GenreCollectionViewCell
        cell.configure(with: genresViewModel.moviesByGenre[indexPath.row],
                       path: genresViewModel.moviesByGenre[indexPath.row].posterPath)
        return cell
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let itemSize = (collectionView.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom + 10)) / 3
    //        return CGSize(width: itemSize, height: itemSize)
    //    }
}

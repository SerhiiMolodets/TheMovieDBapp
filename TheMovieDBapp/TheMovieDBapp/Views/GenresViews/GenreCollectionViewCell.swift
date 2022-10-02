//
//  GenreCollectionViewCell.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import UIKit
import SDWebImage

class GenreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    private var path: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        titleImageView.image = nil
    }
    func configure(with movieByGenre: ResultByGenre, path: String) {
        self.path = path
        self.titleLabel.text = movieByGenre.title
        indicator.startAnimating()
        self.titleImageView.sd_setImage(with: URL(string: (APIs.getImage.rawValue + movieByGenre.posterPath)), completed: { [weak self] _, _, _, _ in
            self?.indicator.stopAnimating()
        })
    }
}

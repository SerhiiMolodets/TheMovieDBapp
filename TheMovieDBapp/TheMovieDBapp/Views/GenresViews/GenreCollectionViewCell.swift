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
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var raitingStackView: UIStackView!
    @IBOutlet weak var raitingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        
    }
    override func prepareForReuse() {
        titleImageView.image = nil
    }
    // MARK: - Configure cell
    func configure(with movieByGenre: Media) {
        indicator.startAnimating()
        self.titleImageView.sd_setImage(with: URL(string: (APIs.getImage.rawValue + (movieByGenre.posterPath ?? ""))),
                                        completed: { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.indicator.stopAnimating()
            self.raitingLabel.text = " \(movieByGenre.voteAverage) "
            
        })
    }
    // MARK: - Configure UI
    private func setupUI() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 20
        raitingStackView.layer.cornerRadius = 5
    }
}

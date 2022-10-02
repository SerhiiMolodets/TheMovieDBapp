//
//  GenreCollectionViewCell.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(with movieByGenre: ResultByGenre) {
        indicator.startAnimating()
        self.titleLabel.text = movieByGenre.title
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: APIs.getImage.rawValue + movieByGenre.posterPath),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.titleImageView.image = image
                    self?.indicator.stopAnimating()
                }
                
            }
        }
    }
}

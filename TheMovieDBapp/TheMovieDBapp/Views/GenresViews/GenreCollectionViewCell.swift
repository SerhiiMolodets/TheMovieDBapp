//
//  GenreCollectionViewCell.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import UIKit
import SDWebImage
import RxSwift

class GenreCollectionViewCell: UICollectionViewCell {
    var bag = DisposeBag()
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var raitingStackView: UIStackView!
    @IBOutlet weak var raitingLabel: UILabel!
    private let transformer = SDImageResizingTransformer(size: CGSize(width: 200, height: 300), scaleMode: .fill)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        titleImageView.image = nil

    }
    // MARK: - Configure cell
    func configure(with movieByGenre: Media) {
        indicator.startAnimating()
        let url = URL(string: (APIs.getImage.rawValue + (movieByGenre.posterPath ?? "")))
        
        titleImageView.sd_setImage(with: url, placeholderImage: nil, context: [.imageTransformer : transformer], progress: nil, completed: { [weak self] _, _, _, _ in
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

//
//  SearchTableViewCell.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 07.10.2022.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var textStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterView.layer.cornerRadius = 30

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with movie: Media) {
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        guard let poster = movie.posterPath else { return }
        indicator.startAnimating()
        self.posterView.sd_setImage(with: URL(string: (APIs.getImage.rawValue + poster)), completed: { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.indicator.stopAnimating()
//            self.raitingLabel.text = " \(movieByGenre.voteAverage) "
            
        })
    }
    
}

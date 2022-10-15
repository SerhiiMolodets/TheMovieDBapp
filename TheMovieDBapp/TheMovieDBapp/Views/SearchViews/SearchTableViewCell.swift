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
        setupUI()
        
    }
    
    // MARK: - Configure cell
    func configure(with movie: Media) {
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        guard let poster = movie.posterPath else { return }
        self.posterView.sd_setImage(with: URL(string: (APIs.getImage.rawValue + poster)), completed: nil)
    }
    // MARK: - Configure UI
    private func setupUI() {
        posterView.layer.cornerRadius = 30
    }
    
}

//
//  FavoriteTableViewCell.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 14.10.2022.
//

import UIKit
import SDWebImage

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewTextView: UITextView!
    
    private let transformer = SDImageResizingTransformer(size: CGSize(width: 100, height: 150), scaleMode: .fill)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    // MARK: - Configure cell
    func configure(_ media: Media) {
        titleLabel.text = (media.title ?? "") + (media.name ?? "")
        overViewTextView.text = media.overview
        posterView.sd_setImage(with: URL(string: (APIs.getImage.rawValue + (media.posterPath ?? ""))),placeholderImage: nil, context: [.imageTransformer : transformer], progress: nil, completed: nil)
    }
    // MARK: - Configure UI
    private func setupUI() {
        posterView.layer.cornerRadius = 20
        posterView.addBorderGradient()
    }
    
}

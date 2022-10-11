//
//  ViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 10.10.2022.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class MoviewDetailViewController: UIViewController {
    var movieDetailViewModel: MoviewDetailViewModel?
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var trailerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var trailerPlayerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
    private func setupUI() {
        guard let movieDetailViewModel = movieDetailViewModel else { return }

        self.posterView.sd_setImage(with: URL(string: (APIs.getImage.rawValue + (movieDetailViewModel.movie.posterPath ?? ""))),
                                    completed: { _, _, _, _ in })
        posterView.layer.cornerRadius = 25
        titleLabel.text = (movieDetailViewModel.movie.title ?? "") + (movieDetailViewModel.movie.name ?? "")
        overviewTextView.text = movieDetailViewModel.movie.overview

    }
    
}

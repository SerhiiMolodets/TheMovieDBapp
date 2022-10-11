//
//  ViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 10.10.2022.
//

import UIKit

class MoviewDetailViewController: UIViewController {
    var movieDetailViewModel: MoviewDetailViewModel?
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var trailerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
    private func setupUI() {
        self.posterView.sd_setImage(with: URL(string: (APIs.getImage.rawValue + (movieDetailViewModel?.movie.posterPath ?? ""))),
                                        completed: { [weak self] _, _, _, _ in
//            guard let self = self else { return }
//            self.indicator.stopAnimating()
//            self.raitingLabel.text = " \(movieByGenre.voteAverage) "
            
        })
        posterView.layer.cornerRadius = 25
    }
    
    
    
}

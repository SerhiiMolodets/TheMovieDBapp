//
//  ViewController.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 10.10.2022.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper
import RxSwift
import RxCocoa

class MoviewDetailViewController: UIViewController {
    var movieDetailViewModel: MoviewDetailViewModel?
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var trailerView: UIView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var trailerPlayerView: YTPlayerView!
    @IBOutlet weak var raitingLabel: UILabel!
    @IBOutlet weak var raitingStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Configure UI
    private func setupUI() {
        guard let movieDetailViewModel = movieDetailViewModel else { return }
        
        self.posterView.sd_setImage(with: URL(string: (APIs.getImage.rawValue + (movieDetailViewModel.movie.posterPath ?? ""))), completed: nil)
        posterView.layer.cornerRadius = 25
        titleLabel.text = (movieDetailViewModel.movie.title ?? "") + (movieDetailViewModel.movie.name ?? "")
        overviewTextView.text = movieDetailViewModel.movie.overview
        raitingLabel.text = "\(movieDetailViewModel.movie.voteAverage) "
        movieDetailViewModel.videoKey
            .drive { [weak self] key in
                guard let self = self else { return }
                    self.trailerPlayerView.load(withVideoId: key)

            }.disposed(by: disposeBag)
        // MARK: - Configure favoriteButton
        favoriteButton.layer.cornerRadius = 6
        favoriteButton.layer.borderWidth = 1
        favoriteButton.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        
        raitingStack.layer.cornerRadius = 8
    }
    // MARK: - Favorite button action, result alert
    @IBAction func favoriteButtonDidTap(_ sender: UIButton) {
        movieDetailViewModel?.updFavorite(add: true, completionHandler: { responce in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Favorites",
                                              message: responce.statusMessage,
                                              preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Ok",
                                              style: UIAlertAction.Style.default,
                                              handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
        favoriteButton.addBorderGradient()
    }
}

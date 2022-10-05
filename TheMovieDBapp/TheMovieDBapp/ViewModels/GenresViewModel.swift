//
//  GenresViewModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import Foundation
import RxSwift
import RxCocoa

class GenresViewModel {
    var movieGenres = BehaviorRelay<[Genre]>(value: [])
    var TVsByGenre: [ResultByGenre] = []
    var tVGenres = BehaviorRelay<[Genre]>(value: [])
    var movieOrTV = BehaviorRelay(value: 0)
    var moviesByGenre: [ResultByGenre] = []
    
    let sourceDataTableView = PublishSubject<Observable<[Genre]>>()
// MARK: - Get movie genres list to genreVM
    func updateMovieGenres() {
        GenresNetworkManager.shared.getMoviesGenres { [weak self] genres in
            guard let self = self else { return }
            self.movieGenres.accept(genres)
            self.sourceDataTableView.onNext(self.movieGenres.asObservable())

        }
    }
    // MARK: - Get TV genres list to genreVM
    func updateTVGenres() {
        GenresNetworkManager.shared.getTVsGenres { [weak self] genres in
            guard let self = self else { return }
            self.tVGenres.accept(genres)
            self.sourceDataTableView.onNext(self.tVGenres.asObservable())
//            self.tVGenres.onCompleted()
        }
    }
    // MARK: - Get movies by genre to genreVM
    func getMovieWith(genre: Int, _ completionHandler: @escaping () -> Void) {
        GenresNetworkManager.shared.getMovies(with: String(genre)) { [weak self] movies in
            guard let self = self else { return }
            self.moviesByGenre = movies
            completionHandler()
        }
    }
    // MARK: - Get TVs by genre to genreVM
    func getTVsWith(genre: Int, _ completionHandler: @escaping () -> Void) {
        GenresNetworkManager.shared.getTVs(with: String(genre)) { [weak self] movies in
            guard let self = self else { return }
            self.TVsByGenre = movies
            completionHandler()
        }
    }

}

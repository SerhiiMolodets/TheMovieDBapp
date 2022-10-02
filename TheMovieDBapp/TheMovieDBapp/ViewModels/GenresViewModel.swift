//
//  GenresViewModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import Foundation

class GenresViewModel {
    var genres: [Genre] = []
    var moviesByGenre: [ResultByGenre] = []
    func updateGenre(_ completionHandler: @escaping () -> Void) {
        GenresNetworkManager.shared.getGenres { [weak self] genres in
            guard let self = self else { return }
            self.genres = genres
        }
    }
    func getMovieWith(genre: Int, _ completionHandler: @escaping () -> Void) {
        GenresNetworkManager.shared.getWithGenre(String(genre)) { [weak self] movies in
            guard let self = self else { return }
            self.moviesByGenre = movies
            completionHandler()
        }
    }
}

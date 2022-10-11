//
//  MovieDetailViewModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 10.10.2022.
//

import Foundation
class MoviewDetailViewModel {
    var movie: ResultByGenre
    
    init(movie: ResultByGenre) {
        self.movie = movie
    }
}

//
//  SearchModels.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 07.10.2022.
//

import Foundation

struct SearchMovie: Codable {
    let page: Int
    let results: [ResultSearch]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ResultSearch: Codable {
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let overview: String
    let popularity: Double
    let posterPath: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case overview, popularity
        case posterPath = "poster_path"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


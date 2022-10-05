//
//  GenresModels.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import Foundation
import RxDataSources

// MARK: - Genres
struct Genres: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// MARK: - MoviesByGenre
struct MoviesByGenre: Codable {
    let page: Int
    let results: [ResultByGenre]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ResultByGenre: Codable, IdentifiableType, Equatable {
    var identity: Int { return id }
    
    typealias Identity = Int
    
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let name: String?
    let overview: String
    let popularity: Double
    let posterPath: String
    let title: String?
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case overview, popularity
        case posterPath = "poster_path"
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
    }
}

struct GenreSection {
    let header: String
    var items: [Item]
}

extension GenreSection: AnimatableSectionModelType {

    typealias Item = ResultByGenre
    typealias Identity = String
    
    init(original: GenreSection, items: [ResultByGenre]) {
        self.items = items
        self = original
    }
    var identity: String {
        return header
    }
}

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
struct Genre: Codable, Equatable {
    let id: Int
    let name: String
}

// MARK: - MoviesByGenre
struct MoviesByGenre: Codable {
    let page: Int
    let results: [Media]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Media: Codable, IdentifiableType, Equatable, Hashable {
    var identity: Int { return id }
    
    typealias Identity = Int
    
    let backdropPath: String?
    let id: Int
    let name: String?
    let overview: String
    let posterPath: String?
    let title: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case overview
        case posterPath = "poster_path"
        case title
        case voteAverage = "vote_average"
        case name
    }
}
// MARK: - Section for RxDataSource
struct GenreSection {
    let header: String
    var items: [Item]
}

extension GenreSection: AnimatableSectionModelType {
    
    typealias Item = Media
    typealias Identity = String
    
    init(original: GenreSection, items: [Media]) {
        self.items = items
        self = original
    }
    var identity: String {
        return header
    }
}

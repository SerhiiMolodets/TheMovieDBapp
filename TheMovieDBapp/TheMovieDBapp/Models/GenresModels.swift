//
//  GenresModels.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import Foundation

// MARK: - Genres
struct Genres: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let moviesByGenre = try? newJSONDecoder().decode(MoviesByGenre.self, from: jsonData)

import Foundation

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
struct ResultByGenre: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: OriginalLanguage
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable {
    case en
    case fr
    case ja
    case te
    case de
    case ko
    case es
    case pl
    case zh
    case ru
    case it
    case ta
    
}

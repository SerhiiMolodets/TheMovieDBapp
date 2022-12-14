//
//  Constans.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 26.09.2022.
//

import UIKit
// MARK: - APIs path and constans
enum APIs: String {
    case apiKey = "07170e6cdbaa64696a3226a414ea7d8d"
    case baseURL = "https://api.themoviedb.org/3/"
    case newToken = "https://api.themoviedb.org/3/authentication/token/new"
    case validateToken = "https://api.themoviedb.org/3/authentication/token/validate_with_login"
    case createSessionId = "https://api.themoviedb.org/3/authentication/session/new"
    case account = "https://api.themoviedb.org/3/account"
    case guestSessionID = "https://api.themoviedb.org/3/authentication/guest_session/new"
    case getMoviesGenreList = "https://api.themoviedb.org/3/genre/movie/list"
    case getTVsGenreList = "https://api.themoviedb.org/3/genre/tv/list"
    case getResultWithGenre = "https://api.themoviedb.org/3/discover/"
    case getImage = "https://image.tmdb.org/t/p/original"
    case searchMovie = "https://api.themoviedb.org/3/search/movie"
    case videos = "/videos"
    case favorite = "/favorite"
    case session = "https://api.themoviedb.org/3/authentication/session"
    // MARK: - Responce check func
    static func checkResponce(_ data: Data?, _ responce: URLResponse?, _ error: Error?, completionHandler: @escaping (Data) -> Void) {
        if error != nil {
            print("error")
        } else if let resp = responce as? HTTPURLResponse,
                  resp.statusCode/200 == 1, let responceData = data {
            completionHandler(responceData)
        }
    }
    
}
// MARK: - Video type
enum VideoType: String {
    case movie
    case tv
}
// MARK: - Request methods
enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
// MARK: - Colors of gradient
struct GradientColors {
    static let start = UIColor(red: 0.453, green: 0.392, blue: 0.824, alpha: 1).cgColor
    static let end = UIColor(red: 0.31, green: 0.702, blue: 0.875, alpha: 1).cgColor
    
}
// MARK: - Error of search
enum SearchError: Error {
    case underlyingError(Error)
    case notFound
    case unkowned
}
// MARK: - Media type
enum MediaType: String {
    case tv
    case movie
    case movies
}

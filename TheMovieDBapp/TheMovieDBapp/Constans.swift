//
//  Constans.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 26.09.2022.
//

import Foundation

enum APIs: String {
    case apiKey = "07170e6cdbaa64696a3226a414ea7d8d"
    case baseURL = "https://api.themoviedb.org/3/"
    case newToken = "https://api.themoviedb.org/3/authentication/token/new"
    case validateToken = "https://api.themoviedb.org/3/authentication/token/validate_with_login"
    case createSessionId = "https://api.themoviedb.org/3/authentication/session/new"
    
}

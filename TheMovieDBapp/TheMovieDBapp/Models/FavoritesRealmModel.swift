//
//  FavoritesRealmModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 15.10.2022.
//

import Foundation
import RealmSwift

class MovieRealm: Object {
    
    @Persisted var backdropPath: String?
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String?
    @Persisted var overview: String
    @Persisted var posterPath: String?
    @Persisted var title: String?
    @Persisted var voteAverage: Double
    
}

class TVRealm: Object {
    
    @Persisted var backdropPath: String?
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String?
    @Persisted var overview: String
    @Persisted var posterPath: String?
    @Persisted var title: String?
    @Persisted var voteAverage: Double
    
}

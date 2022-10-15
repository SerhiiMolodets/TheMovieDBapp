//
//  FavoritesDataManager.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 15.10.2022.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm
import RxRelay

struct FavoritesDataManager {
    let disposeBag = DisposeBag()
    static let shared = FavoritesDataManager()
    private init() { }
    // MARK: - Save movies to Realm
    func save(movie medias: [Media]) {
        DispatchQueue.main.async {
            let realm = try? Realm()
            var movieRealms = [MovieRealm]()
            medias.forEach { media in
                let movieRealm = MovieRealm()
                movieRealm.id = media.id
                movieRealm.overview = media.overview
                movieRealm.voteAverage = media.voteAverage
                movieRealm.name = media.name
                movieRealm.title = media.title
                movieRealm.posterPath = media.posterPath
                movieRealm.backdropPath = media.backdropPath
                movieRealms.append(movieRealm)
            }
            try? realm?.write({
                realm?.add(movieRealms, update: .modified)
            })
        }
        
    }
    // MARK: - Save TVs to Realm
    func save(TV medias: [Media]) {
        DispatchQueue.main.async {
            let realm = try? Realm()
            var tvRealms = [TVRealm]()
            medias.forEach { media in
                let tvRealm = TVRealm()
                tvRealm.id = media.id
                tvRealm.overview = media.overview
                tvRealm.voteAverage = media.voteAverage
                tvRealm.name = media.name
                tvRealm.title = media.title
                tvRealm.posterPath = media.posterPath
                tvRealm.backdropPath = media.backdropPath
                tvRealms.append(tvRealm)
            }
            try? realm?.write({
                realm?.add(tvRealms, update: .modified)
            })
        }
        
    }
    // MARK: - Load movies from Realm
    func loadMovie() -> Observable<[Media]> {
        let result = BehaviorRelay(value: [Media]())
        DispatchQueue.main.async {
            let realm = try? Realm()
            guard let saved = realm?.objects(MovieRealm.self) else { return }
            Observable.collection(from: saved)
                .map { convert(movies: $0) }
                .subscribe { savedResults in
                    result.accept(savedResults.element ?? [])
                }.disposed(by: disposeBag)
        }
        return result.asObservable()
    }
    // MARK: - Load TVs from Realm
    func loadTV() -> Observable<[Media]> {
        let result = BehaviorRelay(value: [Media]())
        DispatchQueue.main.async {
            let realm = try? Realm()
            guard let saved = realm?.objects(TVRealm.self) else { return }
            Observable.collection(from: saved)
                .map { convert(tvs: $0) }
                .subscribe { savedResults in
                    result.accept(savedResults.element ?? [])
                }.disposed(by: disposeBag)
        }
        return result.asObservable()
    }
    // MARK: - Transform Movie Results from Realm to Media
    private func convert(movies: Results<MovieRealm>) -> [Media] {
        var medias: [Media] = []
        movies.forEach { movie in
            let media = Media(backdropPath: movie.backdropPath,
                              id: movie.id,
                              name: movie.name,
                              overview: movie.overview,
                              posterPath: movie.posterPath,
                              title: movie.title,
                              voteAverage: movie.voteAverage)
            medias.append(media)
        }
        return medias
    }
    // MARK: - Transform TVs Results from Realm to Media
    private func convert(tvs: Results<TVRealm>) -> [Media] {
        var medias: [Media] = []
        tvs.forEach { tv in
            let media = Media(backdropPath: tv.backdropPath,
                              id: tv.id,
                              name: tv.name,
                              overview: tv.overview,
                              posterPath: tv.posterPath,
                              title: tv.title,
                              voteAverage: tv.voteAverage)
            medias.append(media)
        }
        return medias
    }
    // MARK: - Reset Realm storage
    func resetCache() {
        let realm = try? Realm()
        try? realm?.write({
            realm?.deleteAll()
        })
    }
}

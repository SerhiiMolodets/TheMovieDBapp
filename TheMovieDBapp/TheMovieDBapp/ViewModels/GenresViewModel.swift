//
//  GenresViewModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class GenresViewModel {
    // MARK: - Movie or TV shows on screen
    static var stateSegment: MediaType = .movie
    // MARK: - List of movie genres
    var movieGenres = BehaviorRelay<[Genre]>(value: [])
    // MARK: - List of TV genres
    var tVGenres = BehaviorRelay<[Genre]>(value: [])
    // MARK: - Create datasource for collectionView and configure cell
    var dataSource = RxCollectionViewSectionedReloadDataSource<GenreSection> { _, collectionView, indexPath, item in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCollectionViewCellId",
                                                      for: indexPath) as! GenreCollectionViewCell
        cell.configure(with: item)
        return cell
    }
    // MARK: - Observable array with results of request movie/TV for collectionView
    var dataCollectionView = BehaviorRelay<[GenreSection]>(value: [GenreSection(header: "result", items: [])])
    
    let sourceDataTableView = PublishSubject<Observable<[Genre]>>()
    // MARK: - Get movie genres list to genreVM
    func updateMovieGenres() {
        GenresNetworkManager.shared.getMoviesGenres { [weak self] genres in
            guard let self = self else { return }
            self.movieGenres.accept(genres)
            self.sourceDataTableView.onNext(self.movieGenres.asObservable().distinctUntilChanged { $0 != $1 })
                
            
        }
    }
    // MARK: - Get TV genres list to genreVM
    func updateTVGenres() {
        GenresNetworkManager.shared.getTVsGenres { [weak self] genres in
            guard let self = self else { return }
            self.tVGenres.accept(genres)
            self.sourceDataTableView.onNext(self.tVGenres.asObservable())
            //            self.tVGenres.onCompleted()
        }
    }
    // MARK: - Get movies by genre to genreVM
    func getMovieWith(genre: Int) {
        GenresNetworkManager.shared.getMovies(with: String(genre)) { [weak self] resultsGenre in
            guard let self = self else { return }
            self.dataCollectionView.accept([GenreSection(header: "movie result", items: resultsGenre)])
        }
    }
    // MARK: - Get TVs by genre to genreVM
    func getTVsWith(genre: Int) {
        GenresNetworkManager.shared.getTVs(with: String(genre)) { [weak self] resultsGenre in
            guard let self = self else { return }
            self.dataCollectionView.accept([GenreSection(header: "TVs result", items: resultsGenre)])
        }
    }
    
}

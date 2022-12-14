//
//  MovieDetailViewModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 10.10.2022.
//

import Foundation
import RxSwift
import RxCocoa

class MoviewDetailViewModel {
    // MARK: - Data object
    var movie: Media
    private let disposeBag = DisposeBag()
    // MARK: - VideKey observable
    private let videoSubject = BehaviorRelay<String>(value: "")
    var videoKey: Driver<String> {
        return videoSubject
            .asDriver(onErrorJustReturn: "")
    }
    // MARK: - Init with getting data
    init(movie: Media) {
        self.movie = movie
        DetailNetworkManager.shared.getVideo(with: movie.id)
            .subscribe { [weak self] key in
                guard let self = self else { return }
                self.videoSubject.accept(key.element!)
            }.disposed(by: disposeBag)
    }
    // MARK: - Add to favorite list func
    func updFavorite(add: Bool, completionHandler: @escaping (FavoriteResponce) -> Void) {
        DetailNetworkManager
            .shared
            .updateFavorites(media: GenresViewModel.stateSegment.rawValue,
                             user: AuthNetworkManager.shared.userID,
                             add: add,
                             mediaID: movie.id,
                             sessionID: AuthNetworkManager.shared.sessionID) { responce in
                completionHandler(responce)
            }
    }
}

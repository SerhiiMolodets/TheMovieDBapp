//
//  Repository.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 15.10.2022.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm
import RxRelay

struct Repository {
    private let disposeBag = DisposeBag()
    
    static let shared = Repository()
    private init() { }
    
    let realm = try? Realm()
    // MARK: - Connection Network and Data managers, setup cache.
    func fetchData(media type: MediaType) -> Observable<[Media]> {
        let result = BehaviorRelay(value: [Media]())
        FavoritesNetworkManager.shared.getFavorites(media: type,
                                                    user: AuthNetworkManager.shared.userID,
                                                    sessionID: AuthNetworkManager.shared.sessionID)
        .subscribe { favoriteMedia in
            guard let media = favoriteMedia.element else { return }
            switch type {
            case .tv:
                FavoritesDataManager.shared.save(TV: media)
                FavoritesDataManager.shared.loadTV().subscribe { media in
                    result.accept(media)
                }.disposed(by: disposeBag)
            case .movie:
                break
            case .movies:
                FavoritesDataManager.shared.save(movie: media)
                FavoritesDataManager.shared.loadMovie().subscribe { media in
                    result.accept(media)
                }.disposed(by: disposeBag)
            }
            
        }.disposed(by: disposeBag)
        return result.asObservable()
    }
    
}

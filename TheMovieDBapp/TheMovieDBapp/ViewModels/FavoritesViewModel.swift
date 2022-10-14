//
//  FavoritesViewModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 14.10.2022.
//

import Foundation
import RxSwift
import RxCocoa

class FavoritesViewModel {
    private let disposeBag = DisposeBag()
    var mediaType: MediaType = .movies
    private let contentSubject = PublishSubject<[Media]>()
    var content: Driver<[Media]> {
        return contentSubject
            .asDriver(onErrorJustReturn: [])
    }
    
    func getList() {
        let list = FavoritesNetworkManager
            .shared
            .getFavorites(media: mediaType,
                          user: AuthNetworkManager.shared.userID,
                          sessionID: AuthNetworkManager.shared.sessionID)
        list.subscribe { [weak self] elements in
            self?.contentSubject.onNext(elements)
        }.disposed(by: disposeBag)
    }
    
}
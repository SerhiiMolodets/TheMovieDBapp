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
    var movie: Media
    private let disposeBag = DisposeBag()
    
    private let videoSubject = BehaviorRelay<String>(value: "")
    var videoKey: Driver<String> {
        return videoSubject
            .asDriver(onErrorJustReturn: "")
    }
    
    init(movie: Media) {
        self.movie = movie
        DetailNetworkManager.shared.getVideo(with: movie.id)
            .subscribe { [weak self] key in
                guard let self = self else { return }
                self.videoSubject.accept(key.element!)
            }.disposed(by: disposeBag)
    }
}

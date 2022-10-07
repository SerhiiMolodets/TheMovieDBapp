//
//  SearchViewModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 07.10.2022.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    private let disposeBag = DisposeBag()
    // inputs
    private let searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return searchSubject.asObserver()
    }
     
    // outputs
    private let loadingSubject = PublishSubject<Bool>()
    var isLoading: Driver<Bool> {
        return loadingSubject
            .asDriver(onErrorJustReturn: false)
    }

    private let errorSubject = PublishSubject<SearchError?>()
    var error: Driver<SearchError?> {
        return errorSubject
            .asDriver(onErrorJustReturn: SearchError.unkowned)
    }

    private let contentSubject = PublishSubject<[ResultSearch]>()
    var content: Driver<[ResultSearch]> {
        return contentSubject
            .asDriver(onErrorJustReturn: [])
    }
    
    func search(byTerm term: String) -> Observable<[ResultSearch]> {
        return SearchNetworkManger.shared.searchAPI(movie: term)
    }
    
    init() {
        searchSubject
            .asObservable()
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.seconds(3), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] term -> Observable<[ResultSearch]> in
                guard let self = self else { return Observable.empty() }
                // every new try to search, the error signal will
                // emit nil to hide the error view
                self.errorSubject.onNext(nil)
                // switch to loading mode
                self.loadingSubject.onNext(true)
                return self.search(byTerm: term)
                    .catch { [weak self] error -> Observable<[ResultSearch]> in
                        guard let self = self else { return Observable.empty() }
                        self.errorSubject.onNext(SearchError.underlyingError(error))
                        return Observable.empty()
                }
            }
            .subscribe(onNext: { [weak self] elements in
                guard let self = self else { return }
                self.loadingSubject.onNext(false)
                if elements.isEmpty {
                    self.errorSubject.onNext(SearchError.notFound)
                } else {
                    self.contentSubject.onNext(elements)
                }
            })
            .disposed(by: disposeBag)
    }
    
}


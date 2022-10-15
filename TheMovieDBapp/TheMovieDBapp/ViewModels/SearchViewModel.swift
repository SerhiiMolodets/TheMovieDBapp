//
//  SearchViewModel.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 07.10.2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewModel {
    private let disposeBag = DisposeBag()
    // MARK: - Search term from searchField
    private let searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return searchSubject.asObserver()
    }
    //    var historyOfSearch = BehaviorRelay<[String]>(value: Array(repeating: "", count: 10))
    
    // MARK: - Is showed indicator of loading
    private let loadingSubject = PublishSubject<Bool>()
    var isLoading: Driver<Bool> {
        return loadingSubject
            .asDriver(onErrorJustReturn: false)
    }
    // MARK: - Error observable
    private let errorSubject = PublishSubject<SearchError?>()
    var error: Driver<SearchError?> {
        return errorSubject
            .asDriver(onErrorJustReturn: SearchError.unkowned)
    }
    // MARK: - Data observable
    private let contentSubject = PublishSubject<[Media]>()
    var content: Driver<[Media]> {
        return contentSubject
            .asDriver(onErrorJustReturn: [])
    }
    // MARK: - Search func
    func search(byTerm term: String) -> Observable<[Media]> {
        //        var bufferArray = historyOfSearch.value
        //        bufferArray.dropLast()
        //        bufferArray.insert(term, at: 0)
        return SearchNetworkManger.shared.searchAPI(movie: term)
    }
    // MARK: - Init with getting data
    init() {
        searchSubject
            .asObservable()
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.seconds(3), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] term -> Observable<[Media]> in
                guard let self = self else { return Observable.empty() }
                // every new try to search, the error signal will
                // emit nil to hide the error view
                self.errorSubject.onNext(nil)
                // switch to loading mode
                self.loadingSubject.onNext(true)
                return self.search(byTerm: term)
                    .catch { [weak self] error -> Observable<[Media]> in
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

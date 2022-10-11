//
//  SearchNetworkManager.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 07.10.2022.
//

import Foundation
import RxSwift

class SearchNetworkManger {
    static let shared = SearchNetworkManger()
    
    func searchAPI(movie: String) -> Observable<[Media]> {
        return Observable.create { observer in
            let url = URL(string: APIs.searchMovie.rawValue)!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue),
                                       URLQueryItem(name: "query", value: movie)]
            let queryURL = components!.url!
            var dataTask: URLSessionDataTask
           dataTask =  URLSession.shared.dataTask(with: queryURL) { (data, responce, error) in
                
                APIs.checkResponce(data, responce, error, completionHandler: { responceData in
                    do { let movies = try JSONDecoder().decode(MoviesByGenre.self, from: responceData)
                        observer.onNext(movies.results)
                    } catch {
                        observer.onError(error)
                        print(error)
                    }
                })
               observer.onCompleted()
            }
            dataTask.resume()
            return Disposables.create {
                return dataTask.cancel()
            }
            
        }
    }
    
    private init() {}
}

//
//  FavoritesNetworkManager.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 14.10.2022.
//

import Foundation
import RxSwift

class FavoritesNetworkManager {
    static let shared = FavoritesNetworkManager()
    private init() {}
    // MARK: - Request of favorites media
    func getFavorites(media type: MediaType,
                      user ID: Int,
                      sessionID: String) -> Observable<[Media]> {
        return Observable.create { observer in
            let url = URL(string: APIs.account.rawValue + "/\(ID)" + APIs.favorite.rawValue +  "/" + type.rawValue)!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue),
                                       URLQueryItem(name: "session_id", value: sessionID),
                                       URLQueryItem(name: "sort_by", value: "created_at.asc")]
            let queryURL = components!.url!
            var dataTask: URLSessionDataTask
            dataTask =  URLSession.shared.dataTask(with: queryURL) { (data, responce, error) in
                
                APIs.checkResponce(data, responce, error, completionHandler: { responceData in
                    do { let media = try JSONDecoder().decode(MoviesByGenre.self, from: responceData)
                        observer.onNext(media.results)
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
    
}

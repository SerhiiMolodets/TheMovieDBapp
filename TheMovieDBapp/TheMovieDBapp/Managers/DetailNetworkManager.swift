//
//  DetailNetworkManager.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 13.10.2022.
//

import Foundation
import RxSwift
class DetailNetworkManager {
    static let shared = DetailNetworkManager()
    private init() {}
    
    // MARK: - Get medias video
    func getVideo(with id: Int) -> Observable<String> {
    return Observable.create { observer in
        let url = URL(string: APIs.baseURL.rawValue +
                      GenresViewModel.stateSegment.rawValue +
                      String(id) +
                      APIs.videos.rawValue)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue)]
        let queryURL = components!.url!
        var dataTask: URLSessionDataTask
       dataTask =  URLSession.shared.dataTask(with: queryURL) { (data, responce, error) in
            
            APIs.checkResponce(data, responce, error, completionHandler: { responceData in
                do { let videos = try JSONDecoder().decode(Video.self, from: responceData)
                    if let firstTrailerKey = videos.results.first?.key {
                        observer.onNext(firstTrailerKey)
                    }

                } catch {
                    observer.onError(error)
                    print(error)
                }
            })
//           observer.onCompleted()
        }
        dataTask.resume()
        return Disposables.create {
            return dataTask.cancel()
        }
    }
    
}
}

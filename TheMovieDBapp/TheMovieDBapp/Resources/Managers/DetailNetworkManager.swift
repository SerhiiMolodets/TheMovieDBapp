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
                          "\(GenresViewModel.stateSegment.rawValue)/" +
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
    // MARK: - Update Favorites request
    func updateFavorites(media type: String,
                         user ID: Int,
                         add: Bool,
                         mediaID: Int,
                         sessionID: String,
                         completionHandler: @escaping (FavoriteResponce) -> Void) {
        let body = FavoriteBodyModel(mediaType: type, mediaID: mediaID, favorite: add)
        let sendData = try? JSONEncoder().encode(body)
        guard let url = URL(string: APIs.account.rawValue + "/\(ID)" + APIs.favorite.rawValue),
              let data = sendData else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue),
                                   URLQueryItem(name: "session_id", value: sessionID)]
        guard let queryURL = components?.url else { return }
        
        var request = URLRequest(url: queryURL)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = data
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            APIs.checkResponce(data, responce, error) { responceData in
                do {
                    let favoriteResponce = try JSONDecoder().decode(FavoriteResponce.self, from: responceData)
                    completionHandler(favoriteResponce)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}

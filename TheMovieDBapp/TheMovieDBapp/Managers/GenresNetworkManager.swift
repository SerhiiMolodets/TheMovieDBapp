//
//  GenresNetworkManager.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import Foundation

class GenresNetworkManager {
    static let shared = GenresNetworkManager()
    
    func getGenres(_ completionHandler: @escaping ([Genre]) -> Void) {
        guard let url = URL(string: APIs.getGenreList.rawValue) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue)]
        guard let queryURL = components?.url else { return }
        URLSession.shared.dataTask(with: queryURL) { (data, responce, error) in
            
            APIs.checkResponce(data, responce, error, completionHandler: { responceData in
                do { let genres = try JSONDecoder().decode(Genres.self, from: responceData)
                    completionHandler(genres.genres)
                } catch {
                    print(error)
                }
            })
        }.resume()
    }
    func getWithGenre(_ genre: String, _ completionHandler: @escaping ([ResultByGenre]) -> Void) {
        guard let url = URL(string: APIs.getResultWithGenre.rawValue) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue),
                                   URLQueryItem(name: "with_genres", value: genre)]
        guard let queryURL = components?.url else { return }
        URLSession.shared.dataTask(with: queryURL) { (data, responce, error) in
            
            APIs.checkResponce(data, responce, error, completionHandler: { responceData in
                do { let moviesByGenre = try JSONDecoder().decode(MoviesByGenre.self, from: responceData)
                    completionHandler(moviesByGenre.results)
                } catch {
                    print(error)
                }
            })
        }.resume()
    }
}

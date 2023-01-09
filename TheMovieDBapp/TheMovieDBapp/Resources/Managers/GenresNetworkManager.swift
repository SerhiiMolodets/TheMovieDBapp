//
//  GenresNetworkManager.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 29.09.2022.
//

import Foundation

class GenresNetworkManager {
    static let shared = GenresNetworkManager()
    // MARK: - Get list of movies genres
    func getMoviesGenres(_ completionHandler: @escaping ([Genre]) -> Void) {
        guard let url = URL(string: APIs.getMoviesGenreList.rawValue) else { return }
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
    // MARK: - Get list of TVs genres
    func getTVsGenres(_ completionHandler: @escaping ([Genre]) -> Void) {
        guard let url = URL(string: APIs.getTVsGenreList.rawValue) else { return }
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
    // MARK: - Get movies with genre
    func getMovies(with genre: String, _ completionHandler: @escaping ([Media]) -> Void) {
        guard let url = URL(string: APIs.getResultWithGenre.rawValue + VideoType.movie.rawValue) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue),
                                   URLQueryItem(name: "with_genres", value: genre)]
        guard let queryURL = components?.url else { return }
        URLSession.shared.dataTask(with: queryURL) { (data, responce, error) in
            
            APIs.checkResponce(data, responce, error, completionHandler: { responceData in
                do { let moviesByGenre = try JSONDecoder().decode(MoviesByGenre.self, from: responceData)
                    let unique = Array(Set(moviesByGenre.results))
                    completionHandler(unique)
                } catch {
                    print(error)
                }
            })
        }.resume()
    }
    // MARK: - Get TVs with genre
    func getTVs(with genre: String, _ completionHandler: @escaping ([Media]) -> Void) {
        guard let url = URL(string: APIs.getResultWithGenre.rawValue + VideoType.tv.rawValue) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue),
                                   URLQueryItem(name: "with_genres", value: genre)]
        guard let queryURL = components?.url else { return }
        URLSession.shared.dataTask(with: queryURL) { (data, responce, error) in
            
            APIs.checkResponce(data, responce, error, completionHandler: { responceData in
                do { let moviesByGenre = try JSONDecoder().decode(MoviesByGenre.self, from: responceData)
                    let unique = Array(Set(moviesByGenre.results))
                    completionHandler(unique)
                } catch {
                    print(error)
                }
            })
        }.resume()
    }
    private init() {}
}

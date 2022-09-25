//
//  NetworkManager.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 23.09.2022.
//

import Foundation

class AuthNetworkManager {
//    Need to delete
    let login = "mr_molodets"
    let password = "mukola123456"
    
    private let apiKey = "07170e6cdbaa64696a3226a414ea7d8d"

    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }

    enum APIs: String {
        case authentication
        case users
        case comments
    }

    private let baseURL = "https://api.themoviedb.org/3/"

    // MARK: - Get new users token
    private func newToken() -> String {
         var usersToken = ""
        guard let url = URL(string: baseURL + APIs.authentication.rawValue + "/token/new") else { return "error URL"}
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: "\(apiKey)")]
        guard let queryURL = components?.url else { return "error queryURL"}

        URLSession.shared.dataTask(with: queryURL) { (data, responce, error) in
            if error != nil {
                print("error")
            } else if let resp = responce as? HTTPURLResponse,
                      resp.statusCode%200 == 0,
                      let receiveData = data {
                let token = try? JSONDecoder().decode(Token.self, from: receiveData)
                usersToken = token?.requestToken ?? "error request"
            }
        }.resume()
        return usersToken
    }
// MARK: - Validate token with userName and password
    func logInWith(username: String, password: String) {
        let token = newToken()

        let validate = ValidateToken(username: login, password: password, requestToken: token)

        let sendData = try? JSONEncoder().encode(validate)
        guard let url = URL(string: baseURL + APIs.authentication.rawValue + "/token/validate_with_login"),
              let data = sendData else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: "\(apiKey)")]
        guard let queryURL = components?.url else { return }

        var request = URLRequest(url: queryURL)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = data
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, responce, error) in
            if error != nil {
                print("error")
            } else if let resp = responce as? HTTPURLResponse,
                      resp.statusCode == 200, let responceData = data {
                print(responceData, resp.statusCode)
                print(token)

            }
        }.resume()

    }

}

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
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    // MARK: - Get new users token
    private func newToken(_ complitionHandler: @escaping (Token) -> Void) {
        guard let url = URL(string: APIs.newToken.rawValue) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue)]
        guard let queryURL = components?.url else { return }
        
        URLSession.shared.dataTask(with: queryURL) { (data, responce, error) in
            if error != nil {
                print("error")
            } else if let resp = responce as? HTTPURLResponse,
                      resp.statusCode%200 == 0,
                      let responceData = data {
                if let token = try? JSONDecoder().decode(Token.self, from: responceData) {
                    complitionHandler(token)
                }
            }
        }.resume()
    }
    // MARK: - Validate token with userName and password
    func logInWith(username: String, password: String, _ complitionHandler: @escaping (Token) -> Void) {
        newToken { token in
            let validate = ValidateToken(username: username, password: password, requestToken: token.requestToken)
            
            let sendData = try? JSONEncoder().encode(validate)
            guard let url = URL(string: APIs.validateToken.rawValue),
                  let data = sendData else { return }
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue)]
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
                    print(token.requestToken)
                    complitionHandler(token)
                }
            }.resume()
        }
    }
}


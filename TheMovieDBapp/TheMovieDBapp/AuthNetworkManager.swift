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
    var sessionID: String?
    
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
        
        URLSession.shared.dataTask(with: queryURL) { [weak self] (data, responce, error) in
            guard let self = self else { return }
            self.checkResponce(data, responce, error, complitionHandler: { responceData in
                if let token = try? JSONDecoder().decode(Token.self, from: responceData) {
                    complitionHandler(token)
                }
            })
        }.resume()
    }
    // MARK: - Validate token with userName and password
    func logInWith(username: String, password: String, _ complitionHandler: @escaping (Token) -> Void) {
        newToken { token in
            let validateBody = ValidateToken(username: username, password: password, requestToken: token.requestToken)
            
            let sendData = try? JSONEncoder().encode(validateBody)
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
            
            URLSession.shared.dataTask(with: request) { [weak self] (data, responce, error) in
                guard let self = self else { return }
                self.checkResponce(data, responce, error) { _ in
                    print(token.requestToken)
                    self.createSession(with: token.requestToken)
                    complitionHandler(token)
                }
            }.resume()
        }
    }
    // MARK: - Create session id
    private func createSession(with token: String) {
        let tokenBody = TokenBody(requestToken: token)
        let sendData = try? JSONEncoder().encode(tokenBody)
        guard let url = URL(string: APIs.createSessionId.rawValue),
              let data = sendData else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue)]
        guard let queryURL = components?.url else { return }
        
        var request = URLRequest(url: queryURL)
        request.httpMethod = HTTPMethod.POST.rawValue
        request.httpBody = data
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {[weak self] (data, responce, error) in
            guard let self = self else { return }
            self.checkResponce(data, responce, error) { responceData in
                if let sessionID = try? JSONDecoder().decode(SessionID.self, from: responceData) {
                    self.sessionID = sessionID.sessionID
                    print("session id " + sessionID.sessionID)
                }
            }
        }.resume()
        
    }
    // MARK: - Standart check of responce func
    func checkResponce(_ data: Data?, _ responce: URLResponse?, _ error: Error?, complitionHandler: @escaping (Data) -> Void) {
        if error != nil {
            print("error")
        } else if let resp = responce as? HTTPURLResponse,
                  resp.statusCode == 200, let responceData = data {
            complitionHandler(responceData)
        }
    }
    
}

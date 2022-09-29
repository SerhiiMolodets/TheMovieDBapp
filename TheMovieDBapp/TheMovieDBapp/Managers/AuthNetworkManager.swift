//
//  NetworkManager.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 23.09.2022.
//

import Foundation

class AuthNetworkManager {
    static let shared = AuthNetworkManager()
    var sessionID = ""
    var token = ""
    var iserID = ""
    
    // MARK: - Standart check of responce func
    private func checkResponce(_ data: Data?, _ responce: URLResponse?, _ error: Error?, completionHandler: @escaping (Data) -> Void) {
        if error != nil {
            print("error")
        } else if let resp = responce as? HTTPURLResponse,
                  resp.statusCode == 200, let responceData = data {
            completionHandler(responceData)
        }
    }
    
    // MARK: - Get new users token
    private func newToken(_ completionHandler: @escaping (Token) -> Void) {
        guard let url = URL(string: APIs.newToken.rawValue) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue)]
        guard let queryURL = components?.url else { return }
        
        URLSession.shared.dataTask(with: queryURL) { [weak self] (data, responce, error) in
            guard let self = self else { return }
            self.checkResponce(data, responce, error, completionHandler: { responceData in
                if let token = try? JSONDecoder().decode(Token.self, from: responceData) {
                    completionHandler(token)
                }
            })
        }.resume()
    }
    // MARK: - Validate token with userName and password
    private  func logInWith(username: String, password: String, _ completionHandler: @escaping () -> Void) {
            let validateBody = ValidateToken(username: username, password: password, requestToken: self.token)
            
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
                    print(self.token)
                    completionHandler()
                }
            }.resume()
    }
    // MARK: - Create session id
    private func createSession(with token: String, completionHandler: @escaping (SessionID) -> Void) {
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
                    print("session id " + sessionID.sessionID)
                    completionHandler(sessionID)
                }
            }
        }.resume()
    }
    // MARK: - Create guests session
    func guestSession(_ completionHandler: @escaping (GuestSessionID) -> Void) {
        guard let url = URL(string: APIs.guestSessionID.rawValue) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue)]
        guard let queryURL = components?.url else { return }
        
        URLSession.shared.dataTask(with: queryURL) { [weak self] (data, responce, error) in
            guard let self = self else { return }
            self.checkResponce(data, responce, error, completionHandler: { responceData in
                if let guestSessionResponce = try? JSONDecoder().decode(GuestSessionID.self, from: responceData) {
                    completionHandler(guestSessionResponce)
                }
            })
        }.resume()
    }
    
    private func getDetails(_ sessionID: String, completionHandler: @escaping () -> Void) {
        guard let url = URL(string: APIs.account.rawValue) else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [ URLQueryItem(name: "api_key", value: APIs.apiKey.rawValue),
                                   URLQueryItem(name: "session_id", value: sessionID)]
        guard let queryURL = components?.url else { return }
        
        URLSession.shared.dataTask(with: queryURL) { [weak self] (data, responce, error) in
            guard let self = self else { return }
            self.checkResponce(data, responce, error, completionHandler: { responceData in
                if let accountDetail = try? JSONDecoder().decode(Account.self, from: responceData) {
                    print("usersID + \(accountDetail.id)")
                    completionHandler()
                }
            })
        }.resume()
    }
    
    func makeMultiRequest(username: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let group = DispatchGroup()
            group.enter()
            self.newToken { newToken in
                self.token = newToken.requestToken
                group.leave()
            }
            group.wait()
            group.enter()
            self.logInWith(username: username, password: password) {
                group.leave()
            }
            group.wait()
            group.enter()
            self.createSession(with: self.token) { requestSessionID in
                self.sessionID = requestSessionID.sessionID
                completionHandler(requestSessionID.success)
                group.leave()
            }
            group.wait()
            group.enter()
            self.getDetails(self.sessionID) {
                group.leave()
            }
        }
    }
    
}


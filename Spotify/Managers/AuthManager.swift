//
//  AuthManager.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import Foundation
final class AuthManager{
    static let shared = AuthManager()
    private init(){}
    private var refreshingToken = false
    public var signInURL: URL?{
        let redirectURI = "https://www.google.com.eg"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.Client_ID)&scope=\(Constants.scope)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    var isSignedIn: Bool{
        return accessToken != nil
    }
    private var accessToken:String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    private var refreshToken:String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    private var tokenExpirationDate:Date?{
        return UserDefaults.standard.object(forKey: "expirationDate")as? Date
    }
    private var shouldRefreshToken:Bool{
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentData = Date()
        let fiveMin = TimeInterval(300)
        print("expirationDate : \(expirationDate)")
        print("current date + fiv min : \(currentData.addingTimeInterval(fiveMin))")
        return currentData.addingTimeInterval(fiveMin) >= expirationDate
    }
    //MARK: -  get token
    public func exchangeCodeForToken(code: String,completion:@escaping((Bool)->Void)){
        guard let url = URL(string: Constants.tokenAPIURL)else{
            return
        }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.Client_ID+":"+Constants.Client_Secret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString()else{
            print("failed to get base 64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data , error == nil else {
                completion(false)
                return
            }
            do {
                // get data
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                print("success : \(data)")
                completion(true)
            } catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    //MARK: - supply Valid token to be used in api caller
    private var onRefreshingBlocks = [((String)-> Void)]()
    public func withValidToken(completion: @escaping (String)-> Void){
        guard !refreshingToken else{
            // append completion
            onRefreshingBlocks.append(completion)
            return
        }
        if shouldRefreshToken{
            // refresh
            refreshIfNeeded {[weak self] success in
                if let token = self?.accessToken , success{
                    completion(token)
                }
            }
        }else if let token = accessToken{
            completion(token)
        }
    }
    //MARK: - Refresh token
    public func refreshIfNeeded(completion: ((Bool)-> Void)?){
        guard !refreshingToken else{
            return
        }
        guard shouldRefreshToken else{
            completion?(true)
            return
        }
        guard let refreshToken = self.refreshToken else{
            return
        }
        // refresh token
        guard let url = URL(string: Constants.tokenAPIURL)else{
            return
        }
        refreshingToken = true
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.Client_ID+":"+Constants.Client_Secret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString()else{
            print("failed to get base 64")
            completion?(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        request.httpBody = components.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.refreshingToken = false
            guard let data = data , error == nil else {
                completion?(false)
                return
            }
            do {
                // get data
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                self?.onRefreshingBlocks.forEach({$0(result.access_token)})
                self?.onRefreshingBlocks.removeAll()
                print("successfully refresh the token : \(data)")
                completion?(true)
            } catch{
                print(error.localizedDescription)
                completion?(false)
            }
        }
        task.resume()
    }
    //MARK: -  Get Token
    private func cacheToken(result: AuthResponse){
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        // date of user login in + expire_in
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}

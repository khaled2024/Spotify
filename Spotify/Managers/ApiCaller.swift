//
//  ApiCaller.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import Foundation

enum HttpMethod: String{
    case post
    case GET
}
enum APIERROR: Error {
    case failedToGetData
}
struct Constant{
    static let baseApiUrl = "https://api.spotify.com/v1"
}
class ApiCaller{
    static let shared = ApiCaller()
    private init(){}
    
    //MARK: - Create genaric request
    private func createRequest(with url: URL?,type: HttpMethod , completion: @escaping (URLRequest)-> Void){
        AuthManager.shared.withValidToken { token in
            guard let apiUrl = url else{
                return
            }
            var request = URLRequest(url: apiUrl)
            request.httpMethod = type.rawValue
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.timeoutInterval = 30
            completion(request)
        }
        
    }
    //MARK: - GetUserProfile
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile,Error>)-> Void){
        createRequest(with: URL(string: Constant.baseApiUrl + "/me"), type: .GET, completion: { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, response, error in
                guard error == nil ,let data = data else{
                    completion(.failure(APIERROR.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    print(result)
                    completion(.success(result))
                } catch  {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        })
    }
}

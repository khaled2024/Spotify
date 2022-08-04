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
enum APIError: Error {
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
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                } catch  {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        })
    }
    //MARK: - get new Releases albums
    //&country=EG
    public func getNewReleases(completion: @escaping (Result <NewReleasesResponse , Error>)-> Void){
        createRequest(with: URL(string: "\(Constant.baseApiUrl)/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with:request) { data, response, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch{
                    completion(.failure(error))
                    print("failed to get releases data \(error)")
                }
            }
            task.resume()
        }
    }
    //MARK: - get Featured playlist
    //&country=EG
    public func getFeaturedPlaylist(completion: @escaping (Result<FeaturedPlaylistsResponse , Error>)-> Void){
        createRequest(with: URL(string: "\(Constant.baseApiUrl)/browse/featured-playlists?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with:request) { data, response, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                } catch{
                    completion(.failure(error))
                    print("failed to get featured release data \(error)")
                }
            }
            task.resume()
        }
    }
    
    //MARK: - get Recommendation
    public func getRecommendation(genres: Set<String>,completion: @escaping (Result<RecommendationsResponse , Error>)-> Void){
        //&country=EG
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: "\(Constant.baseApiUrl)/recommendations?limit=40&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with:request) { data, response, error in
                guard let data = data , error == nil else {
                    
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                } catch{
                    completion(.failure(error))
                    print("failed to get Recommendation data \(error)")
                }
            }
            task.resume()
        }
    }
    //MARK: - get recommendations geners
    public func getRecommendationGenres(completion: @escaping (Result<RecommendedGenresResponse , Error>)-> Void){
        createRequest(with: URL(string: "\(Constant.baseApiUrl)/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with:request) { data, response, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch{
                    completion(.failure(error))
                    print("failed to getRecommendation-Genres \(error)")
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get album details
    public func getAlbumDetails(for album: Album , completion: @escaping (Result<AlbumDetailsResponse,Error>)-> Void){
        createRequest(with: URL(string: Constant.baseApiUrl + "/albums/" + album.id) , type: .GET) {
            request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard  error == nil , let data = data else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    print(result)
                    completion(.success(result))
                } catch  {
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - Get playlist details
    public func getPlaylistDetails(for playlist: Playlist , completion: @escaping (Result<PlaylistDetailsResponse,Error>)-> Void){
        createRequest(with: URL(string: Constant.baseApiUrl + "/playlists/" + playlist.id), type: .GET) {
            request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard  error == nil , let data = data else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - Get audio track details
    
    
    //MARK: - Get all Categories
    public func getCategories(completion: @escaping (Result <[Category],Error>)->Void){
        createRequest(with: URL(string: Constant.baseApiUrl + "/browse/categories?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil ,let data = data else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AllCatogeriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - Get single Category
    public func getCategoryPlaylist(category: Category,completion: @escaping (Result <[Playlist],Error>)->Void){
        createRequest(with: URL(string: Constant.baseApiUrl + "/browse/categories/\(category.id)/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil ,let data = data else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
                    let playlist = result.playlists.items
                    completion(.success(playlist))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
}

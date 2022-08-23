//
//  ApiCaller.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import Foundation
import UIKit
import CoreMedia

enum HttpMethod: String{
    case POST
    case GET
    case DELETE
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
    //MARK: -  get all current user playlists
    public func getCurrentUserPlaylist(compleation: @escaping (Result<[Playlist] , Error>)-> Void){
        createRequest(with: URL(string: Constant.baseApiUrl + "/me/playlists?limit=10"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil , let data = data  else {
                    compleation(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
                    compleation(.success(result.items))
                } catch  {
                    print(error.localizedDescription)
                    compleation(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    //MARK: -  get all current User Albums
    public func getCurrentUserAlbums(compleation: @escaping (Result<[Album] , Error>)-> Void){
        createRequest(with: URL(string: Constant.baseApiUrl + "/me/albums"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil , let data = data  else {
                    compleation(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
//                    JSONSerialization.jsonObject(with: data)
//                    print(result)
                    
                    compleation(.success(result.items))
                } catch  {
                    print(error.localizedDescription)
                    compleation(.failure(error))
                }
            }
            task.resume()
        }
    }

    //MARK: - Create playlist
    public func createPlaylist(with name: String , complation: @escaping (Bool)-> Void){
        getCurrentUserProfile { [weak self] result in
            switch result{
            case .success(let profile):
                let urlString = Constant.baseApiUrl + "/users/\(profile.id)/playlists"
                print(urlString)
                self?.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
                    var request = baseRequest
                    let json =  [
                        "name": name,
                        "public": false
                    ] as [String : Any]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    print("starting creation")
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data , error == nil else{
                            complation(false)
                            return
                        }
                        do {
                            let result = try JSONSerialization.jsonObject(with: data , options: .allowFragments)
                            if let response = result as? [String:Any],response["id"] as? String != nil {
                                print("created")
                                complation(true)
                            }else{
                                print("failed to get id")
                                complation(false)
                            }
                            print(result)
                        } catch  {
                            print(error.localizedDescription)
                            complation(false)
                        }
                    }
                    task.resume()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //MARK: - add track to playlist
    public func addTrackToPlaylist(track: AudioTrack , playlist: Playlist , completion: @escaping (Bool)-> Void){
        createRequest(with: URL(string: Constant.baseApiUrl+"/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
            var request = baseRequest
            let json = [
                "uris" :[
                    "spotify:track:\(track.id)"
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil , let data = data else{
                    completion(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    if let response = result as? [String:Any], response["snapshot_id"] as? String != nil {
                        print(result)
                        completion(true)
                    }
                } catch  {
                    completion(false)
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    //MARK: -  remove track from playlist
    public func removeTrackFromPlaylist(track: AudioTrack, playlist: Playlist, completion: @escaping (Bool)-> Void){
        createRequest(with: URL(string: Constant.baseApiUrl+"/playlists/\(playlist.id)/tracks"), type: .DELETE) { baseRequest in
            var request = baseRequest
            let json : [String:Any] = [
                "tracks": [
                    [
                        "uri" : "spotify:track:\(track.id)"
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil , let data = data else{
                    completion(false)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    if let response = result as? [String:Any],
                       response["snapshot_id"] as? String != nil {
                        print(result)
                        completion(true)
                    }
                } catch  {
                    completion(false)
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
        
    }
    //MARK: - search
    // query.addingPercentEncoding to when user write a space in query didt handle this space
    public func search(query: String , completion: @escaping (Result< [SearchResult] , Error>)->Void){
        createRequest(with: URL(string: Constant.baseApiUrl + "/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            print(request.url?.absoluteString ?? "non")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({SearchResult.track(model: $0)}))
                    searchResults.append(contentsOf: result.albums.items.compactMap({SearchResult.album(model: $0)}))
                    searchResults.append(contentsOf: result.artists.items.compactMap({SearchResult.artist(model: $0)}))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({SearchResult.playlist(model: $0)}))
                    completion(.success(searchResults))
                } catch  {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
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

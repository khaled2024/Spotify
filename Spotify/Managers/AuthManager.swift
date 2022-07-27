//
//  AuthManager.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import Foundation
final class AuthManager{
    
    static let shared = AuthManager()
    private init(){
    }
    public var signInURL: URL?{
        let scope = "user-read-private"
        let redirectURI = "https://www.google.com.eg"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.Client_ID)&scope=\(scope)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool{
        return false
    }
    private var accessToken:String?{
        return nil
    }
    private var refreshToken:String?{
        return nil
    }
    private var tokenExpirationDate:Date?{
        return nil
    }
    private var shouldRefreshToken:Bool{
        return false
    }
    //token
    public func exchangeCodeForToken(
        code:String,
        completion:@escaping((Bool)->Void)
    ){
    }
    public func refreshAccessToken(){
    }
    // Get Token
    private func cacheToken(){
    }
}

//
//  AuthManager.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/03/2022.
//

import Foundation
final class AuthManager{
    
    struct Constants {
        static let ClientID = "c53b440812424b95a5e55b9e19eff504"
        static let ClientSecret = "5a7c7294d06346be99eef7cc6d1dc607"
    }
    static let shared = AuthManager()
    private init(){}
    
    var isSignedIn: Bool{
        return false
    }
    private var accessToken: String?{
        return nil
    }
    private var refreshToken: String?{
        return nil
    }
    private var tokenExpriationDate: Date?{
        return nil
    }
    private var shouldRefreshToken: Bool?{
        return false
    }
}

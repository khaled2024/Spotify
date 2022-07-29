//
//  UserProfile.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import Foundation

struct UserProfile:Codable{
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String:Bool]
    let external_urls: [String:String]
    let id: String
    let product: String
    let images: [UserImage]
//    let type: String
//    let uri: String
    
}
struct UserImage: Codable{
    let url:String
}



//{

//    href = "https://api.spotify.com/v1/users/i5c6qamlje9f1hr4j6vhpzqin";
//    images =     (
//    );
//    type = user;
//    uri = "spotify:user:i5c6qamlje9f1hr4j6vhpzqin";
//}

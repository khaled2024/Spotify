//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 30/07/2022.
//

import Foundation

struct NewReleasesResponse:Codable{
    let albums:AlbumsResponse
}
struct AlbumsResponse:Codable{
    let items:[Album]
}
struct Album:Codable{
    let album_type:String
    let available_markets:[String]
    let id:String
    let images:[ApiImage]
    let name:String
    let release_date:String
    let total_tracks:Int
    let artists:[Artist]
}


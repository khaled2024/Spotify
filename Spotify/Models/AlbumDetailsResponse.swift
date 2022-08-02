//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 02/08/2022.
//

import Foundation
struct AlbumDetailsResponse: Codable{
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String:String]
    let id: String
    let images: [ApiImage]
    let label: String
    let name: String
    let tracks: TrackResponse
    
}
struct TrackResponse:Codable{
    let items: [AudioTrack]
}

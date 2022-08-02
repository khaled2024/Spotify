//
//  PlaylistDetailsResponse.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 02/08/2022.
//

import Foundation

struct PlaylistDetailsResponse: Codable{
    let description: String
    let external_urls :[String:String]
    let id: String
    let images: [ApiImage]
    let name: String
    let tracks: PlaylistTrackResponse
}

struct PlaylistTrackResponse:Codable{
    let items: [PlaylistItem]
}

struct PlaylistItem:Codable{
    let track: AudioTrack
}

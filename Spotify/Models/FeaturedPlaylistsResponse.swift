//
//  FeaturedPlaylist.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 30/07/2022.
//

import Foundation

struct FeaturedPlaylistsResponse:Codable{
    let playlists: PlaylistResponse
}
struct CategoryPlaylistsResponse: Codable{
    let playlists: PlaylistResponse
}
struct PlaylistResponse:Codable{
    let items:[Playlist]
}

struct User:Codable{
    let display_name:String
    let external_urls:[String:String]
    let id:String
}

//
//  SearchResultResponse.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 05/08/2022.
//

import Foundation

struct SearchResultResponse: Codable{
    let albums: SearchAlbumResponse
    let artists: SearchArtistResponse
    let playlists: SearchPlaylistResponse
    let tracks: SearchTracksResponse
}
struct SearchAlbumResponse:Codable{
    let items: [Album]
}
struct SearchArtistResponse:Codable{
    let items: [Artist]
}
struct SearchPlaylistResponse:Codable{
    let items: [Playlist]
}
struct SearchTracksResponse:Codable{
    let items: [AudioTrack]
}

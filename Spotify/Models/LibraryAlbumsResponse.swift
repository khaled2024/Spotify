//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 21/08/2022.
//

import Foundation
struct LibraryAlbumsResponse: Codable{
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable{
    let added_at: String
    let album: Album
}

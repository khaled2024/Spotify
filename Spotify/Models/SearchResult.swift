//
//  SearchResult.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 05/08/2022.
//

import Foundation
enum SearchResult {
    case artist(model:Artist)
    case album(model:Album)
    case track(model:AudioTrack)
    case playlist(model:Playlist)
}

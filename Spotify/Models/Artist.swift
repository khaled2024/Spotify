//
//  Artist.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import Foundation
struct Artist:Codable{
    let id:String
    let name:String
    let type:String
    let external_urls:[String:String]
}

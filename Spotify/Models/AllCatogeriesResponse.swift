//
//  AllCatogeriesResponse.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 04/08/2022.
//

import Foundation
struct AllCatogeriesResponse: Codable{
    let categories: Categories
}
struct Categories: Codable {
    let items: [Category]
}
struct Category: Codable{
    let id: String
    let name: String
    let icons: [ApiImage]
}
      

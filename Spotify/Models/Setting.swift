//
//  Setting.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 29/07/2022.
//

import Foundation
struct Setting{
    let title: String
    let option: [Option]
}
struct Option{
    let title: String
    let handler: ()-> Void
}

//
//  AuthResponse.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 28/07/2022.
//

import Foundation
import UIKit
//{
//    "access_token" = "BQDdFhn3GhJlgCBCOYjzCFTOCSYBXfuApLMYOrQL4_eyXYdw6AnR9e6EwZ57ZT04IsuKd81LuudsGnMoNC6eIUIiVGktHJzLJp6D6yLzL27XDIR8oN0lg5xvwl-_iK1O-rmpE2Z6nHOIlMTNa4NA2vURlUJ_6QIoydsdKs2J20Z3LHsyHUe4W7pKUQ0OE3SutAVfmc0jStzWquA";
//    "expires_in" = 3600;
//    "refresh_token" = "AQBkThzjJaEdr8ttWzL80uEuY_ezm6aFDp4gd1ABZNENFKYMxrHPAEErC5RxUkCDwlAC2zDFO6uOLR2afDx1sikAmgViFflwQNmwuzcd9_YblCNNWDRm_mV6p-dpkF1TGZQ";
//    scope = "user-read-private";
//    "token_type" = Bearer;
//}
struct AuthResponse: Codable{
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
    
}

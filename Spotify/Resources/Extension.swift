//
//  Extension.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 28/03/2022.
//

import Foundation
import UIKit

extension UIView{
    var width: CGFloat{
        return frame.size.width
    }
    var height: CGFloat{
        return frame.size.height
    }
    var left: CGFloat{
        return frame.origin.x
    }
    var right: CGFloat{
        return left + width
    }
    var top: CGFloat{
        return frame.origin.y
    }
    var button: CGFloat{
        return top + height
    }
    
}

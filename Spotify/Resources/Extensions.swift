//
//  Extensions.swift
//  Spotify
//
//  Created by KhaleD HuSsien on 27/07/2022.
//

import Foundation
import UIKit

extension UIView{
    public var width: CGFloat {
        return self.frame.size.width
    }
    public var height: CGFloat {
        return self.frame.size.height
    }
    public var top: CGFloat {
        return self.frame.origin.y
    }
    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left: CGFloat {
        return self.frame.origin.x
    }
    public var right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}
extension DateFormatter{
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()
    static let displayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
}
extension String{
    static func formattedDate(string: String)-> String{
        guard let date = DateFormatter.dateFormatter.date(from:string)else{
            return string
        }
        return DateFormatter.displayDateFormatter.string(from:date)
    }
    
}

extension Notification.Name {
    static let albumSavedNotification = Notification.Name("albumSavedNotification")
}

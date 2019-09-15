//
//  NoteExtension.swift
//  Note
//
//  Created by Yaroslav Zakharchuk on 6/24/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import Foundation
import UIKit

extension Note {
    var json: [String: Any] {
        get {
            var transformNote = [String: Any]()
            transformNote["uid"] = self.uid
            transformNote["title"] = self.title
            transformNote["content"] = self.content
            if self.color != .white {
                transformNote["color"] = self.color.toHexString()
            }
            if self.priority != .regular {
                transformNote["importance"] = self.priority.rawValue
            }
            transformNote["destroyDate"] = self.destroyDate?.timeIntervalSince1970
            return transformNote
        }
    }
    
    static func parse(json: [String: Any]) -> Note? {
        guard let title = json["title"] as? String,
            let content = json["content"] as? String else { return nil }
        let uid = json["uid"] as? String ?? UUID().uuidString
        let color = UIColor.init(hex: json["color"] as? String ?? "#ffffff")
        let importance = Importance(rawValue: json["importance"] as? String ?? "regular")
        var destroyDate: Date?
        if let destroyTimeInterval = json["destroyDate"] as? TimeInterval {
            destroyDate = Date(timeIntervalSince1970: destroyTimeInterval)
        }
        
        return Note(uid: uid, title: title, content: content, color: color!, priority: importance!, destroyDate: destroyDate)
    }
}

extension UIColor {
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
            let red = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            let green = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            let blue = CGFloat(hexNumber & 0x000000ff) / 255

            self.init(red: red, green: green, blue: blue, alpha: alpha)
            return
        }
        return nil
    }

    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        return String(format:"#%06x", rgb)
    }
}

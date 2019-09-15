//
//  Note.swift
//  Note
//
//  Created by Yaroslav Zakharchuk on 6/24/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import Foundation
import UIKit

enum Importance: String {
    case unimportant
    case regular
    case important
}

struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let priority: Importance
    let destroyDate: Date?
    let createDate: Date = Date()
    
    init(uid: String = UUID().uuidString, title: String, content: String, color: UIColor = UIColor.white, priority: Importance, destroyDate: Date?) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.priority = priority
        self.destroyDate = destroyDate
    }
}

class NoteBook {
    static let shared = NoteBook()
    private init() {}
    var notes: [Note] = []
}

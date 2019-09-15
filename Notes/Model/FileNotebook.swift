//
//  FileNotebook.swift
//  Note
//
//  Created by Yaroslav Zakharchuk on 6/27/19.
//  Copyright © 2019 Yaroslav Zakharchuk. All rights reserved.
//

import Foundation
import CocoaLumberjack

class FileNotebook {
    static let shared = FileNotebook()
    private(set) var notes = [String:Note]()
    private let fileManager = FileManager.default
    
    private init() {}
    
    public func add(_ note: Note) {
        notes[note.uid] = note
        DDLogInfo("Note added")
    }
    
    public func remove(with uid: String) {
        if let _ = notes[uid] {
            notes.removeValue(forKey: uid)
            DDLogInfo("Note deleted")
        }
    }
    
    public func saveToFile() {
        let jsonNotes = notes.map({ $0.value.json })
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonNotes, options: .prettyPrinted)
            try jsonData.write(to: getPath()!)
        } catch {
            print(error)
            DDLogError("File could not be saved")
        }
    }
    
    public func loadFromFile() {
        do {
            let dataFromJSON = try Data(contentsOf: getPath()!)
            let parseNote = try JSONSerialization.jsonObject(with: dataFromJSON, options: .mutableContainers)
            let json = parseNote as! [[String: Any]]
            for item in json {
                if let note = Note.parse(json: item) {
                    self.add(note)
                }
            }
        } catch {
            print(error)
        }
    }
    
    public func getSortedArray() -> [Note] {
        return Array(notes.values).sorted(by: {
            $0.createDate.compare($1.createDate) == .orderedDescending
        })
    }
    
    private func getPath() -> URL? {
        let path = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        return path?.appendingPathComponent("note.json")
    }
}

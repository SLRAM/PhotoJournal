//
//  PhotoJournalModel.swift
//  PhotoJournal
//
//  Created by Stephanie Ramirez on 1/15/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation

final class PhotoJournalModel {
    private static let filename = "PhotoJournalPickerList.plist"
    private static var posts = [PhotoJournal]()
    
    private init() {} // this makes initializer private
    static func addPost(post: PhotoJournal) { //adds post to pList
        posts.append(post)
        savePhotoJournal()
    }
    
    static func savePhotoJournal() { //saves current pList status
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        
        do {
            let data = try PropertyListEncoder().encode(posts)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("property list encoder: \(error)")
        }
    }
    static func getPhotoJournal() -> [PhotoJournal] { //to view the photos on the main controller
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
//        var photoJournals = [PhotoJournal]()
        
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    posts = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
                    print("\(filename) does exist")
                } catch {
                    print("Property list decoding error: \(error)")
                }
            } else {
                print("getPhotoJournal - data is nil")
            }
        } else {
            print("\(filename) does not exist")
        }
        return posts
    }
}

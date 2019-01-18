//
//  PhotoJournalModel.swift
//  PhotoJournal
//
//  Created by Stephanie Ramirez on 1/15/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

final class PhotoJournalModel {
    private static let filename = "PhotoJournalPickerList.plist"
    private static var photoJournals = [PhotoJournal]()
    
    private init() {}
    static func appendPhotoJournal(photoJournal: PhotoJournal) {
        photoJournals.append(photoJournal)
        savePhotoJournal()
    }
    static func savePhotoJournal() {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        
        do {
            let data = try PropertyListEncoder().encode(photoJournals)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("property list encoder: \(error)")
        }
    }
    static func deletePhotoJournal(index: Int) {
        photoJournals.remove(at: index)
        savePhotoJournal()
    }
    static func editPhotoJournal(index: Int, photoJournal: PhotoJournal) {
        photoJournals[index] = photoJournal
        savePhotoJournal()
    }
    static func getPhotoJournal() -> [PhotoJournal] {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    photoJournals = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
                } catch {
                    print("Property list decoding error: \(error)")
                }
            } else {
                print("getPhotoJournal - data is nil")
            }
        } else {
            print("\(filename) does not exist")
        }
        photoJournals = photoJournals.sorted {$0.createdAt > $1.createdAt}

        return photoJournals
    }
}

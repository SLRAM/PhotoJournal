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
    private static var posts = [PhotoJournal]()
    
    private init() {}
    static func addPost(post: PhotoJournal) {
        posts.append(post)
        savePhotoJournal()
    }
    
    static func savePhotoJournal() {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename)
        
        do {
            let data = try PropertyListEncoder().encode(posts)
            try data.write(to: path, options: Data.WritingOptions.atomic)
        } catch {
            print("property list encoder: \(error)")
        }
    }
    static func deletePhotoJournal(index: Int) {
        posts.remove(at: index)
        savePhotoJournal()
    }
    static func editPhotoJournal(index: Int) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "AddPhotoViewController") as? AddPhotoViewController else { return }
        destinationViewController.modalPresentationStyle = .currentContext
        print(index)
        destinationViewController.photoJournal = posts[index]
        destinationViewController.indexNumber = index
//        present(destinationViewController, animated: true, completion: nil)
    }
    static func getPhotoJournal() -> [PhotoJournal] {
        let path = DataPersistenceManager.filepathToDocumentsDirectory(filename: filename).path
        
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    posts = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
                } catch {
                    print("Property list decoding error: \(error)")
                }
            } else {
                print("getPhotoJournal - data is nil")
            }
        } else {
            print("\(filename) does not exist")
        }
        posts = posts.sorted {$0.createdAt > $1.createdAt}

        return posts
    }
}

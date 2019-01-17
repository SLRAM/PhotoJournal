//
//  DataPersistenceManager.swift
//  PhotoJournal
//
//  Created by Stephanie Ramirez on 1/15/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation

final class DataPersistenceManager {
    
    //path to documents directory
    static func documentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    //filespath using filename to documents directory
    static func filepathToDocumentsDirectory(filename: String) -> URL {
        return documentsDirectory().appendingPathComponent(filename)
    }
}

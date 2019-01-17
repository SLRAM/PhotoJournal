//
//  PhotoJournal.swift
//  PhotoJournal
//
//  Created by Stephanie Ramirez on 1/15/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation

struct PhotoJournal: Codable {
    let createdAt: String
    let imageData: Data
    let description: String
}

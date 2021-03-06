//
//  PhotoJournalImageCell.swift
//  PhotoJournal
//
//  Created by Stephanie Ramirez on 1/15/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

protocol PhotoJournalImageCellDelegate: AnyObject {
    func actionSheet(tag: Int)
}

class PhotoJournalImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    weak var delegate: PhotoJournalImageCellDelegate?
    
    @IBAction func optionsButtonClicked(_ sender: UIButton) {
        self.delegate?.actionSheet(tag: sender.tag)
    }
}

//
//  ViewController.swift
//  PhotoJournal
//
//  Created by Stephanie Ramirez on 1/14/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

class PhotoJournalViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var myPhotos = [PhotoJournal]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    //UIAlertViewController alertcontroller.addaction(delete action, etc) with action (.alert), .actionsheet
    //if you don't have a device don'timplement sharing 
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        print(DataPersistenceManager.documentsDirectory())
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let imageCell = segue.destination as? PhotoJournalImageCell else {return}
//        imageCell.delegate = self
//    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        
    }

}
extension PhotoJournalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoJournalModel.getPhotoJournal().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoJournalImageCell", for: indexPath) as? PhotoJournalImageCell else { return UICollectionViewCell()}
        let photo = PhotoJournalModel.getPhotoJournal()[indexPath.row]
        cell.layer.cornerRadius = 20.0
        cell.descriptionLabel.text = photo.description
        cell.timestampLabel.text = photo.createdAt
        cell.imageView.image = UIImage(data: photo.imageData)
        cell.delegate = self
        return cell

    }
    
    
}

extension PhotoJournalViewController: UICollectionViewDelegate {
    
}

extension PhotoJournalViewController: PhotoJournalImageCellDelegate {
    func actionSheet() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "Delete", style: .default)
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        let editAction = UIAlertAction(title: "Edit", style: .default)
        let shareAction = UIAlertAction(title: "Share", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(editAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }

}

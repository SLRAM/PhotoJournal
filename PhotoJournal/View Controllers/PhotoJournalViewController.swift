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
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        myPhotos = PhotoJournalModel.getPhotoJournal()
        print(DataPersistenceManager.documentsDirectory())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myPhotos = PhotoJournalModel.getPhotoJournal()
        collectionView.reloadData()
    }
    private func editPhotoJournal(index: Int) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "AddPhotoViewController") as? AddPhotoViewController else { return }
        destinationViewController.modalPresentationStyle = .currentContext
        destinationViewController.photoJournal = myPhotos[index]
        destinationViewController.indexNumber = index
        present(destinationViewController, animated: true, completion: nil)
    }
    private func sharePhotoJournal(index: Int) {
        if let imageToShare = UIImage(data: myPhotos[index].imageData) {
            let descriptionToShare = myPhotos[index].description
            let activityViewController = UIActivityViewController(activityItems: [imageToShare, descriptionToShare], applicationActivities: nil)
            present(activityViewController, animated: true)
        }
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
        cell.optionsButton.tag = indexPath.row
        cell.delegate = self
        return cell
    }
}
extension PhotoJournalViewController: PhotoJournalImageCellDelegate {
    func actionSheet(tag: Int) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let  deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            PhotoJournalModel.deletePhotoJournal(index: tag)
            self.collectionView.reloadData()
        })
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: { (action) -> Void in
            print(tag)
            self.editPhotoJournal(index: tag)
            self.collectionView.reloadData()
        })
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: { (action) -> Void in
            print(tag)
            self.sharePhotoJournal(index: tag)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(editAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}
extension PhotoJournalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 375, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20)
    }
}

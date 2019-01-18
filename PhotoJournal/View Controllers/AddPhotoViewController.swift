//
//  AddPhotoViewController.swift
//  PhotoJournal
//
//  Created by Stephanie Ramirez on 1/14/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

class AddPhotoViewController: UIViewController {

    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    private var imagePickerViewController: UIImagePickerController!
    private var descriptionPlaceholder = " Enter photo description..."
    private var imagePlaceholder = UIImage(named: "placeholder-image.jpeg")
    var photoJournal: PhotoJournal?
    var indexNumber = 0


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(tapGesture)
        setupImagePickerViewController()
    }
    
    @IBAction func screenTapped(_ sender: Any) {
        descriptionView.resignFirstResponder()
    }
    

    private func showImagePickerController() {
        present(imagePickerViewController, animated: true, completion: nil)
    }
 
    private func setupImagePickerViewController() {
        print("here")
        if let photoJournal = photoJournal {
            descriptionView.text = photoJournal.description
            descriptionView.textColor = .black
            if let image = UIImage(data: photoJournal.imageData) {
                imageView.image = image
            }
        } else {
            descriptionView.text = descriptionPlaceholder
            descriptionView.textColor = .lightGray
            imageView.image = imagePlaceholder
            descriptionView.isEditable = false
            saveButton.isEnabled = false
            

        }
        
        
        descriptionView.delegate = self
        imagePickerViewController =  UIImagePickerController()
        imagePickerViewController.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = false
        }
    }
    private func saveJournal()-> PhotoJournal? {
        guard let image = imageView.image,
        let imageDescription = descriptionView.text else {return nil}
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = .medium
        let timestamp = formatter.string(from: date)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return nil}
        let photoJournal = PhotoJournal.init(createdAt: timestamp, imageData: imageData, description: imageDescription)
        return photoJournal
    }

    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        guard let journal = saveJournal() else {return}
        PhotoJournalModel.addPost(post: journal)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonClicked(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func photoLibraryButtonClicked(_ sender: Any) {
        imagePickerViewController.sourceType = .photoLibrary
        showImagePickerController()
    }
}
extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            saveButton.isEnabled = true
            descriptionView.isEditable = true
            
        } else {
            print("original image is nil")
        }
        dismiss(animated: true, completion: nil)
    }
}
extension AddPhotoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionView.text == descriptionPlaceholder {
            descriptionView.text = ""
            descriptionView.textColor = .black
        }
    }
    
}

//
//  PhotoPickerViewController.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/14/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

protocol PhotoPickerViewControllerDelegate: class {
    func photoPickerViewControllerSelected(image: UIImage)
}

class PhotoPickerViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    //MARK: - properties
    weak var delegate: PhotoPickerViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage {
            selectPhotoButton.setTitle("", for: .normal)
            photoImageView.image = photo
            delegate?.photoPickerViewControllerSelected(image: photo)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "photos", style: .default, handler: { (_) in
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker,animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePicker, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    
    
}// end of class

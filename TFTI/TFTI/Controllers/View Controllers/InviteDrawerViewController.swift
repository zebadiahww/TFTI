//
//  InviteViewController.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/6/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

protocol InviteViewControllerDelegate: class {
    func createEventButtonTapped()
    func viewContactsButtonTapped()
    func timeSelectorTapped()
}

class InviteDrawerViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    weak var delegate: InviteViewControllerDelegate?
    
    //MARK: - Outlets
    @IBOutlet var inviteDatePicker: UIDatePicker!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet var datePickerToolBar: UIToolbar!
    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ratingImageVIew: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerTextField.inputView = inviteDatePicker
        datePickerTextField.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        datePickerTextField.inputAccessoryView = datePickerToolBar
        return true
    }
    
    func updateViewsWith(business: Business) {
        businessNameLabel.text = business.name
        ratingCountLabel.text = "\(business.reviewCount) Reviews"
        guard let rating = business.rating else { return }
        BusinessController.convertYelpRating(rating: rating)
        ratingImageVIew.image = BusinessController.reviewImage
        businessImageView.image = nil
        BusinessController.getImage(item: business) { (image) in
            if let image = image {
                DispatchQueue.main.async {
                    self.businessImageView.image = image
                }
            } else {
                print("image was nil")
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
    @IBAction func createButtonTapped(_ sender: Any) {
    }
    @IBAction func contactsButtonTapped(_ sender: Any) {
    }
    @IBAction func doneButonTapped(_ sender: Any) {
        datePickerTextField.text = inviteDatePicker.date.formatDate()
        view.endEditing(true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  LoginViewController.swift
//  TFTI
//
//  Created by Zebadiah Watson on 11/6/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var image: UIImage?
    
    //MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    //MARK: - Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
    }
    
    
    
    //MARK: - Class Methods
    func setupViews() {
        
    }
    
    func fetchUser() {
        
    }
    
}

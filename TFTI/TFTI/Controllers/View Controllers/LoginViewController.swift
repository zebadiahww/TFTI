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
        fetchUser()
        
    }
    
    
    //MARK: - Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else { return}
        
        UserController.shared.createUserWith(name: username, profileImage: image) { (success) in
            if success {
                self.showMapViewVC()
            }
        }
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
    }
    
    
    
    //MARK: - Class Methods
    func setupViews() {
        
    }
    
    func fetchUser() {
        UserController.shared.fetchUser { (success) in
            if success {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Invite", bundle: nil)
                    guard let vc = storyboard.instantiateInitialViewController() else { return }
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    func showMapViewVC() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Invite", bundle: nil)
            guard let vc = storyboard.instantiateInitialViewController() else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
}

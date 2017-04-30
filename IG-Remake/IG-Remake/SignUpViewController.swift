//
//  SignUpViewController.swift
//  IG-Remake
//
//  Created by Anthony Washington on 4/26/17.
//  Copyright © 2017 Anthony Washington. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Profile image button.
    let photoButton: UIButton = {
        let button = UIButton()
            button.setImage(UIImage(named: "plus_photo"), for: .normal)
            button.addTarget(self, action: #selector(pickProfilePic), for: .touchUpInside)
        return button
    }()
    
    // Signup button
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
            button.setTitle("Sign Up", for: .normal)
            button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
            button.isEnabled = false
        return button
    }()
    
    // Email textfield
    let emailField: UITextField = {
        let email = UITextField()
            email.placeholder = "Email"
            email.backgroundColor = UIColor(white: 0, alpha: 0.03)
            email.borderStyle = .roundedRect
            email.font = UIFont.systemFont(ofSize: 14)
            email.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        return email
    }()
    
    // Username textfield
    let usernameField: UITextField = {
        let username = UITextField()
            username.placeholder = "Username"
            username.backgroundColor = UIColor(white: 0, alpha: 0.03)
            username.borderStyle = .roundedRect
            username.font = UIFont.systemFont(ofSize: 14)
            username.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        return username
    }()
    
    // Password textfield
    let passwrdField: UITextField = {
        let psswd = UITextField()
            psswd.placeholder = "Password"
            psswd.isSecureTextEntry = true
            psswd.backgroundColor = UIColor(white: 0, alpha: 0.03)
            psswd.borderStyle = .roundedRect
            psswd.font = UIFont.systemFont(ofSize: 14)
            psswd.addTarget(self, action: #selector(validateForm), for: .editingChanged)
        return psswd
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add photbutton
        // set button width and height constraint
        // center photobutton
        view.addSubview(photoButton)
        
        photoButton.anchors(top: view.topAnchor, topPad: 40, left: nil, leftPad: nil, right: nil, rightPad: nil, height: 140, width: 140, center: view.centerXAnchor)
        
        // add stackview for signup fields
        setupSignUpFields()
    }
    
    // sign up users
    func signUp() {
        
        guard let email = emailField.text, !email.isEmpty else { return }
        guard let name = usernameField.text, !name.isEmpty else { return }
        guard let psswd = passwrdField.text, !psswd.isEmpty else { return }
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: psswd, completion: { (user, error) in
        
            if let err = error {
                print("Error creating user: ", err)
                return
            }
            
            print("Successfully created user: ", user?.uid ?? "")
            
            guard let uid = user?.uid  else { return }
            let value = [uid : name]
            
            FIRDatabase.database().reference().updateChildValues(value, withCompletionBlock: { (error, ref) in
                
                if let err = error {
                    print("Error: \(err)")
                    print("Error saving username to DB for user \(uid)")
                }
                
                print("Successfully save user \(uid) username to DB.")
            })
        })
    }
    
    // checks form fields are filled with values
    func validateForm() {
        
        let valid = !(emailField.text?.isEmpty)! && (!(usernameField.text?.isEmpty)!) && ((passwrdField.text?.characters.count)! > 6)
        
        if valid {
            signupButton.isEnabled = true
            signupButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }
        else {
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    
    // image picker for profile
    func pickProfilePic() {
        let picker = UIImagePickerController()
            picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    fileprivate func setupSignUpFields() {
        let stackView = UIStackView(arrangedSubviews: [emailField, usernameField, passwrdField, signupButton])
            stackView.axis = .vertical
            stackView.spacing = 10
            stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        stackView.anchors(top: photoButton.bottomAnchor, topPad: 20, left: view.leftAnchor, leftPad: 40, right: view.rightAnchor, rightPad: 40, height: 200, width: nil, center: nil)
    }
}

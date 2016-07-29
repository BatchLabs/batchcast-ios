//
//  LoginCredentialsViewController.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit

class LoginCredentialsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var premium: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Make the keyboard dismiss when we tap outside of a field
        let tapper = UITapGestureRecognizer(target: view, action:#selector(UIView.endEditing))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInAction(_ sender: AnyObject) {
        if let emailString = email.text , emailString.trimmingCharacters(in: CharacterSet.whitespaces) != "" {
            
            let userManager = UserManager()
            if !userManager.isLoggedIn {
                userManager.login(emailString, premium: premium.isOn)
            } else {
                // Invalid state, ignore
            }
            
            if !PushManager().didTriggerSystemPopup {
                performSegue(withIdentifier: "enablePushSegue", sender: self)
            } else {
                dismiss(animated: true, completion: nil)
            }
            
        } else {
            // Invalid email
            let alert = UIAlertController(title: "Invalid Login",
                                          message: "Please enter a valid email",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            signInAction(textField)
        } else {
            return true
        }
        
        return false
    }
}

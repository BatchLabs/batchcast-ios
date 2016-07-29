//
//  LoginLandingViewController.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit

class LoginLandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserManager().onboardingAttempted = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func notNowAction(_ sender: AnyObject) {
        if !PushManager().didTriggerSystemPopup {
            performSegue(withIdentifier: "enablePushSegue", sender: self)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

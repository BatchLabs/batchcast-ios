//
//  LoginEnableNotificationsViewController.swift
//  Batchcast
//
//  Copyright © 2016 BatchLabs. All rights reserved.
//

import UIKit

class LoginEnableNotificationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func allowAction(_ sender: AnyObject) {
        PushManager().register()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func laterAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

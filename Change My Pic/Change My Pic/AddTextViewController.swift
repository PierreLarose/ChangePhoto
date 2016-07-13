//
//  AddTextViewController.swift
//  Change My Pic
//
//  Created by Pierre Larose on 11/24/14.
//  Copyright (c) 2014 Pierre Larose. All rights reserved.
//

import UIKit
import Accounts

class AddTextViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var profileImage : UIImage? = nil
    var twitterAccount : ACAccount? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let publishPicViewController = segue.destinationViewController as! PublishPicViewController
        publishPicViewController.profileImage = self.profileImage
        publishPicViewController.imageText = self.textField.text!
        publishPicViewController.twitterAccount = self.twitterAccount
    }
    
}

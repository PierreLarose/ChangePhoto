//
//  SignInViewController.swift
//  Change My Pic
//
//  Created by Pierre Larose on 11/24/14.
//  Copyright (c) 2014 Pierre Larose. All rights reserved.
//

import UIKit
import Accounts
import Social

class SignInViewController: UIViewController {

    var twitterAccount : ACAccount? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Roll Tide...
        
        
    }

    @IBAction func twitterTapped(sender: AnyObject) {
        let account = ACAccountStore()
        
        let accountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            
            if granted {
                let allAccounts = account.accountsWithAccountType(accountType)
                if allAccounts.count > 0 {
                    let twitterAccount = allAccounts.last as! ACAccount
                    self.twitterAccount = twitterAccount
                    
                    let requestAPI = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
                    
                    let userRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestAPI, parameters: nil)
                    
                    userRequest.account = twitterAccount
                    
                    userRequest.performRequestWithHandler({ (response:NSData!, urlResponse:NSHTTPURLResponse!, error:NSError!) -> Void in
                        
                        var error = NSErrorPointer()
                        
                        let responseDictionary = (try! NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.MutableLeaves)) as! [String : AnyObject]
                        
                        var imageURL = responseDictionary["profile_image_url_https"] as! String
                        
                        imageURL = imageURL.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        
                        let imageRequest = NSURLRequest(URL: NSURL(string: imageURL)!)
                        
                        NSURLConnection.sendAsynchronousRequest(imageRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (imageResponse:NSURLResponse?, imageData:NSData?, imageError:NSError?) -> Void in
                            let image = UIImage(data: imageData!)
                            self.performSegueWithIdentifier("SignInToTextSegue", sender: image)
                        })
                    })
                }
            } else {
                print("Access not granted...shoot 😞")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let addTextViewController = segue.destinationViewController as! AddTextViewController
        addTextViewController.profileImage = (sender as! UIImage)
        addTextViewController.twitterAccount = self.twitterAccount
    }


}

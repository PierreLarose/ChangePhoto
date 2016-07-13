//
//  PublishPicViewController.swift
//  Change My Pic
//
//  Created by Pierre Larose on 11/28/14.
//  Copyright (c) 2014 Pierre Larose. All rights reserved.
//

import UIKit
import Accounts
import Social

class PublishPicViewController: UIViewController {
    
    var profileImage : UIImage? = nil
    var imageText = ""
    var twitterAccount : ACAccount? = nil

    @IBOutlet weak var profilePicImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Roll Tide...
        
        self.profilePicImageView.image = editPic(self.imageText, image: self.profileImage!)
    }
    
    func editPic(text : String, image : UIImage) -> UIImage {
        
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        UIColor(white: 0, alpha: 0.8).set()
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, image.size.height-(image.size.height*0.2), image.size.width, (image.size.height*0.2)))
        
        let rect = CGRectMake(0, image.size.height-(image.size.height*0.2), image.size.width, (image.size.height*0.2))
        let newText : NSString = text
        let style = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        style.alignment = NSTextAlignment.Center
        let attrs = [NSFontAttributeName : UIFont.systemFontOfSize((image.size.height*0.17)), NSForegroundColorAttributeName : UIColor.whiteColor(), NSParagraphStyleAttributeName : style]
        newText.drawInRect(CGRectIntegral(rect), withAttributes: attrs)
        
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    @IBAction func updateTapped(sender: AnyObject) {
        let requestAPI = NSURL(string: "https://api.twitter.com/1.1/account/update_profile_image.json")
        
        let picData = UIImagePNGRepresentation(self.profilePicImageView.image!)
        let base64Image = picData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let userRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: requestAPI, parameters: ["image":base64Image])
        
        userRequest.account = self.twitterAccount
        
        userRequest.performRequestWithHandler({ (response:NSData!, urlResponse:NSHTTPURLResponse!, error:NSError!) -> Void in
            
            var error = NSErrorPointer()
            
            let responseDictionary = (try! NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.MutableLeaves)) as! [String : AnyObject]
            if urlResponse.statusCode == 200 {
                let alertController = UIAlertController(title: "Pic Updated!", message: "Congrats! Your Twitter pic was updated!", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "Awesome!", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(alertAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Uh-Oh!", message: "We were unable to update your pic. Sorry dude...", preferredStyle: UIAlertControllerStyle.Alert)
                let alertAction = UIAlertAction(title: "This stinks 😥", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(alertAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
}
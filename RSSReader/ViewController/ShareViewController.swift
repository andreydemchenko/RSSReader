//
//  ShareViewController.swift
//  RSSReader
//
//  Created by zuzex-62 on 29.12.2022.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    var sharedIdentifier = "group.com.DemoSharedEx"
    var selectedImage: UIImage!
    var maxCharacterCount = 100
    
    override func viewDidLoad() {
        super.viewDidLoad ()
        placeholder = "Write content here"
    }
    
    override func isContentValid() -> Bool {
        if let currentMessage = contentText {
            let currentMessageLength = currentMessage.count
            charactersRemaining = (maxCharacterCount - currentMessageLength) as NSNumber
            if Int(truncating: charactersRemaining) < 0 {
                Utils.showMessage(title: "Sorry", message: "Enter only 100 characters", vc: self)
                return false
            }
        }
        return false
    }
    
    override func didSelectPost() {
        dataAttachment()
    }
    
    func dataAttachment() {
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeImage as String
        for attachment in content.attachments! {
            if attachment.hasItemConformingToTypeIdentifier (contentType) {
                attachment.loadItem(forTypeIdentifier: contentType, options: nil) { data, error in
                    if error == nil {
                        let url = data as! NSURL
                        if let imageData = NSData(contentsOf: url as URL) {
                            Utils.saveDataToUserDefault(suiteName: self.sharedIdentifier, dataKey: "Image", dataValue: imageData)
                        } else {
                            Utils.showMessage(title: "Sorry", message: "Could not load the image", vc: self)
                        }
                    }
                }
            }
        }
        Utils.saveDataToUserDefault(suiteName: self.sharedIdentifier, dataKey: "Name", dataValue: contentText as AnyObject)
    }
}

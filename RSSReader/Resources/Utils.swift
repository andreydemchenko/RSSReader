//
//  Utils.swift
//  RSSReader
//
//  Created by zuzex-62 on 29.12.2022.
//

import Foundation
import UIKit

class Utils {
    
    static func saveDataToUserDefault(suiteName: String, dataKey: String, dataValue: AnyObject) {
        if let prefs = UserDefaults(suiteName: suiteName) {
            prefs.removeObject(forKey: dataKey)
            prefs.setValue(dataValue, forKey: dataKey)
        }
    }
    
    static func showMessage(title: String, message: String!, vc: UIViewController) {
        let alert = UIAlertController(title: "", message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            _ in
        }
        alert.addAction (okAction)
        vc.present(alert, animated: true)
    }
    
    static func shareData(data: NewsModel, vc: UIViewController) {
        let dataToShare = [ data.link ]
        let activityViewController = UIActivityViewController(activityItems: dataToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        vc.present(activityViewController, animated: true, completion: nil)
    }

}

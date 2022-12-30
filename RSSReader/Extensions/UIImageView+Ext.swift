//
//  UIImage+Ext.swift
//  RSSReader
//
//  Created by zuzex-62 on 29.12.2022.
//

import Foundation
import UIKit

extension UIImageView {

 public func imageFromURL(urlString: String) {

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }

}

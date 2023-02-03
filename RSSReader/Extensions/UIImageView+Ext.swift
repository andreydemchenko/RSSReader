//
//  UIImage+Ext.swift
//  RSSReader
//
//  Created by zuzex-62 on 29.12.2022.
//

import Foundation
import UIKit

extension UIImageView {

    public func imageFromURL(urlString: String, placeholderImage: UIImage = UIImage(named: "placeholderImage")!) {
        
        self.image = placeholderImage

        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "No Error")
                return
            }
            let image = UIImage(data: data!)
            DispatchQueue.main.async(execute: { () -> Void in
                self.image = image
            })
            if let url = URL(string: urlString) {
                appContext.imageCache[url] = image
            }

        }).resume()
    }

}

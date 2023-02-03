//
//  String+Ext.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import Foundation
import UIKit

extension String {
    
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
        return dateFormatter.date(from: self) ?? Date()
    }
    
    var getImageFromPath: UIImage? {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        if let path = paths.first {
            let imageURL = URL(fileURLWithPath: path).appendingPathComponent(self)
            if let data = try? Data(contentsOf: imageURL) {
                return UIImage(data: data)
            }
            return nil
        }
        return nil
    }
    
}

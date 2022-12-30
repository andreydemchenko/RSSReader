//
//  Date+Ext.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import Foundation

extension Date {
    
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, hh:mm"
        return dateFormatter.string(from: self)
    }
    
    var toStringNewsFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY hh:mm"
        return dateFormatter.string(from: self)
    }
    
}

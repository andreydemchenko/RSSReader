//
//  String+Ext.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import Foundation

extension String {
    
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss ZZZ"
        return dateFormatter.date(from: self) ?? Date()
    }
    
}

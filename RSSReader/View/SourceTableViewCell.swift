//
//  SourceTableViewCell.swift
//  RSSReader
//
//  Created by zuzex-62 on 11.01.2023.
//

import UIKit

class SourceTableViewCell: UITableViewCell {

    @IBOutlet private weak var linkLbl: UILabel!
    @IBOutlet private weak var nameLbl: UILabel!
    
    func setViews(item: SourceModel) {
        linkLbl.text = item.link
        nameLbl.text = item.name
    }
    
}

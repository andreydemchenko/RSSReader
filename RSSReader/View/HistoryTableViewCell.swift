//
//  HistoryTableViewCell.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var linkLbl: UILabel!
    @IBOutlet private weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setViews(item: NewsModel) {
   
    }
    
}

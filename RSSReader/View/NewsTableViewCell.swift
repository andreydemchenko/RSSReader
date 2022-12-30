//
//  NewsTableViewCell.swift
//  RSSReader
//
//  Created by zuzex-62 on 29.12.2022.
//

import UIKit

protocol NewsTableViewCellProtocol: AnyObject {
    func shareNews(data: NewsModel)
}

class NewsTableViewCell: UITableViewCell {

    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var dateLbl: UILabel!
    @IBOutlet private weak var descriptionLbl: UILabel!
    @IBOutlet private weak var clickedAtLbl: UILabel!
    
    private var newsModel: NewsModel?
    var delegateObject: NewsTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction
    private func shareBtnClicked(_ sender: Any) {
        if let newsModel, let delegateObject {
            delegateObject.shareNews(data: newsModel)
        }
    }
    
    func setViews(item: NewsModel) {
        newsModel = item
        newsImageView.imageFromURL(urlString: item.imageUrl)
        (titleLbl.text, descriptionLbl.text, dateLbl.text) = (item.title, item.description, item.pubDate.toStringNewsFormat)
        if let clickedDate = item.clickDate {
            clickedAtLbl.isHidden = false
            clickedAtLbl.text = clickedDate.toString
        } else {
            clickedAtLbl.isHidden = true
        }
    }
    
}

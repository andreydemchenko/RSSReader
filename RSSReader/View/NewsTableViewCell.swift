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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //newsImageView.image = nil
    }
    
    private var newsModel: NewsModel?
    weak var delegateObject: NewsTableViewCellProtocol?
    
    @IBAction
    private func shareBtnClicked(_ sender: Any) {
        if let newsModel, let delegateObject {
            delegateObject.shareNews(data: newsModel)
        }
    }
    
    func setViews(item: NewsModel) {
        newsModel = item
        newsImageView.image = nil
        if item.imageUrl.isEmpty {
            newsImageView.isHidden = true
        } else {
            newsImageView.isHidden = false
            if let url = URL(string: item.imageUrl) {
                if let image = appContext.imageCache[url] {
                    newsImageView.image = image
                } else {
                    newsImageView.imageFromURL(urlString: item.imageUrl)
                }
            }
        }
        (titleLbl.text, descriptionLbl.text, dateLbl.text) = (item.title, item.description, item.pubDate.toStringNewsFormat)
        if let clickedDate = item.clickDate {
            clickedAtLbl.isHidden = false
            clickedAtLbl.text = clickedDate.toString
        } else {
            clickedAtLbl.isHidden = true
        }
    }
    
}

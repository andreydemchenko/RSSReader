//
//  NewsViewController.swift
//  RSSReader
//
//  Created by zuzex-62 on 09.01.2023.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noticeLbl: UILabel!
    
    var rssItems: [NewsModel]? {
        didSet {
            hideIfNeeded()
            tableView.reloadData()
        }
    }
    var newsTitle = "News"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = newsTitle
        
        hideIfNeeded()

        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        tableView.estimatedRowHeight = 330
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setData(items: [NewsModel]?) {
        rssItems?.removeAll()
        rssItems = items
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    private func hideIfNeeded() {
        let isData = rssItems != nil
        noticeLbl.isHidden = isData
        tableView.isHidden = !isData
    }

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
            fatalError("Could not dequeue cell of type NewsTableViewCell")
        }
        
        if let item = rssItems?[indexPath.row] {
            cell.setViews(item: item)
            cell.delegateObject = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = rssItems?[indexPath.row], let url = URL(string: item.link) {
            UIApplication.shared.open(url)
            appContext.historyCoreDataManager.addItem(item: item)
            updateHistoryVC()
        }
    }
    
    private func updateHistoryVC() {
        if let mainTBC = navigationController?.tabBarController as? MainTabBarController {
            if let newsNVC = mainTBC.viewControllers?[2] as? UINavigationController {
                if let historyVC = newsNVC.viewControllers.first as? HistoryViewController {
                    historyVC.getData()
                }
            }
        }
    }
    
}

extension NewsViewController: NewsTableViewCellProtocol {
    
    func shareNews(data: NewsModel) {
        Utils.shareData(data: data, vc: self)
    }
    
}

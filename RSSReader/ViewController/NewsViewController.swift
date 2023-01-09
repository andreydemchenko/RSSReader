//
//  NewsViewController.swift
//  RSSReader
//
//  Created by zuzex-62 on 09.01.2023.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var rssItems: [NewsModel]?
    
    private var sharedIdentifier = "group.com.zuzex.RSSReader.SharedExt"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()

        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        tableView.estimatedRowHeight = 330
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setNavBar() {
        let rightBarButton = UIBarButtonItem(title: "History", style: .done, target: self, action: #selector(goToHistory))
    
        navigationItem.title = "StupdNews"
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = .orange
    }
    
    @objc
    private func goToHistory() {
        let vc = HistoryViewController(nibName: "History", bundle: nil)
        vc.title = "History"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
            appContext.coreDataManager.addItem(item: item)
        }
    }
    
}

extension NewsViewController: NewsTableViewCellProtocol {
    
    func shareNews(data: NewsModel) {
        Utils.shareData(data: data, vc: self)
    }
    
}


//
//  HistoryViewController.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet private  weak var tableView: UITableView!
    
    private var dataSource = [NewsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        tableView.estimatedRowHeight = 330
        tableView.rowHeight = UITableView.automaticDimension
        
        getData()
    }
    
    private func getData() {
        dataSource.removeAll()
        dataSource = appContext.coreDataManager.getItems()
        dataSource.reverse()
        tableView.reloadData()
    }

}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
            fatalError("Could not dequeue cell of type NewsTableViewCell")
        }
        cell.setViews(item: dataSource[indexPath.row])
        cell.delegateObject = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        if let url = URL(string: item.link) {
            UIApplication.shared.open(url)
            appContext.coreDataManager.addItem(item: item)
            getData()
        }
    }
    
}

extension HistoryViewController: NewsTableViewCellProtocol {
    
    func shareNews(data: NewsModel) {
        Utils.shareData(data: data, vc: self)
    }
    
}

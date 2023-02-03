//
//  ViewController.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBtn: UIButton!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorLbl: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var loadingView: UIView! {
        didSet {
            loadingView.layer.cornerRadius = 6
        }
    }
    
    private let feedParser = FeedParser()
    private var rssItems: [NewsModel]?
    
    private let group = DispatchGroup()
    
    private var dataSource: [SourceModel] = []
    private var sourceName = "News"
    private var editAtIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("⭐️⭐️⭐️⭐️⭐️")
        textField.text = "https://www.mensjournal.com/feed/"
        errorLbl.text = nil
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SourceTableViewCell", bundle: nil), forCellReuseIdentifier: "SourceCell")
        getData()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        view.addGestureRecognizer(longPressRecognizer)
    }
    
    private func getData() {
        dataSource.removeAll()
        dataSource = appContext.coreDataManager.getSourceItems()
        dataSource.reverse()
        tableView.reloadData()
    }
    
    @objc
    private func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == .began {
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let item = dataSource[indexPath.row]
                showAlert(item: item)
            }
        }
    }
    
    private func showAlert(item: SourceModel) {
        let alert = UIAlertController(title: "\(item.name)", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler: { (UIAlertAction) in
            if let index = self.dataSource.firstIndex(where: { $0.id == item.id }) {
                self.editAtIndex = index
                self.textField.text = item.link
                self.textField.becomeFirstResponder()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Copy url", style: .default , handler: { (UIAlertAction) in
            UIPasteboard.general.string = item.link
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler: { (UIAlertAction) in
            appContext.coreDataManager.deleteSourceItem(link: item.link)
            self.getData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
 
    
    @IBAction
    private func searchBtnClicked(_ sender: Any) {
        getData()
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty || textField.text == nil {
            errorLbl.text = "Enter URL!"
        } else {
            dismissKeyboard()
            if let text = textField.text {
                if verifyUrl(urlString: text) {
                    sourceName = feedParser.getNewsName()
                    parse(url: text, name: sourceName)
                } else {
                    errorLbl.text = "Invalid URL!"
                }
            }
        }
    }
    
    private func showSpinner() {
        activityIndicator.startAnimating()
        loadingView.isHidden = false
        searchBtn.isHidden = true
    }

    private func hideSpinner() {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
        searchBtn.isHidden = false
    }
    
    private func verifyUrl(urlString: String) -> Bool {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    private func parse(url: String, name: String) {
        group.enter()
        showSpinner()
        feedParser.parseFeed(feedURL: url) { [weak self] rssItems in
            self?.rssItems = rssItems
            if self?.getDispatchGroupCount() == 1 {
                self?.group.leave()
            } else {
                DispatchQueue.main.async {
                    self?.errorLbl.text = "Time out"
                }
            }
        }
        group.notify(queue: .global(qos: .background)) { [weak self] in
            if let self {
                DispatchQueue.main.async {
                    self.hideSpinner()
                    if let rssItems = self.rssItems, !rssItems.isEmpty {
                        let model = SourceModel(id: UUID().uuidString, link: url, name: name)
                        appContext.coreDataManager.addSourceItem(item: model)
                        self.getData()
                        self.errorLbl.text = nil
                        self.openNewsController()
                        self.sourceName = "News"
                    } else {
                        self.errorLbl.text = "There is no data"
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0, execute: {
            if self.getDispatchGroupCount() == 1 {
                self.group.leave()
            }
        })
    }
    
    private func openNewsController() {
        if let mainTBC = navigationController?.tabBarController as? MainTabBarController {
            if let newsNVC = mainTBC.viewControllers?[1] as? UINavigationController {
                if let newsVC = newsNVC.viewControllers.first as? NewsViewController {
                    mainTBC.rssDataSource = self.rssItems
                    newsVC.setData(items: rssItems)
                    mainTBC.selectedIndex = 1
                }
            }
        }
    }
    
    private func getDispatchGroupCount() -> Int {
        let count = self.group.debugDescription.components(separatedBy: ",").filter({ $0.contains("count") }).first?.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap{ Int($0) }.first
        return count ?? 0
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath) as? SourceTableViewCell else {
            fatalError("Could not dequeue cell of type SourceTableViewCell")
        }
        cell.selectionStyle = .none
        cell.setViews(item: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        parse(url: item.link, name: item.name)
        dismissKeyboard()
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

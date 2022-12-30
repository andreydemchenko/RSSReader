//
//  ViewController.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var errorLbl: UILabel!
    
    private let feedParser = FeedParser()
    private var rssItems: [NewsModel]?
    
    private let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = "https://news.un.org/feed/subscribe/ru/news/region/europe/feed/rss.xml"
        errorLbl.text = nil
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction
    private func searchBtnClicked(_ sender: Any) {
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty || textField.text == nil {
            errorLbl.text = "Enter URL!"
        } else {
            if let text = textField.text {
                if verifyUrl(urlString: text) {
                    errorLbl.text = nil
                    parse(url: <#T##String#>)
                } else {
                    errorLbl.text = "Invalid URL!"
                }
            }
        }
    }
    
    func verifyUrl(urlString: String) -> Bool {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    private func parse(url: String) {
        group.enter()
        feedParser.parseFeed(feedURL: url) { [weak self] rssItems in
            self?.rssItems = rssItems
            self?.group.leave()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let newsVC = segue.destination as? NewsViewController else { return }
        newsVC.rssItems = rssItems
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toNewsViewControllerSegue" {
           return true
        }
        return false
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

//
//  ViewController.swift
//  RSSReader
//
//  Created by zuzex-62 on 30.12.2022.
//

import UIKit

class ViewController: UIViewController {

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
    
    private let spinner = SpinnerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //textField.text = "https://rss.nytimes.com/services/xml/rss/nyt/Business.xml"
        textField.text = "https://feeds.a.dj.com/rss/WSJcomUSBusiness.xml"
        errorLbl.text = nil
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction
    private func searchBtnClicked(_ sender: Any) {
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty || textField.text == nil {
            errorLbl.text = "Enter URL!"
        } else {
            dismissKeyboard()
            if let text = textField.text {
                if verifyUrl(urlString: text) {
                    parse(url: text)
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
    
    private func parse(url: String) {
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
                        self.errorLbl.text = nil
                        self.openNewsController()
                    } else {
                        self.errorLbl.text = "There is no data"
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            if self.getDispatchGroupCount() == 1 {
                self.group.leave()
            }
        })
    }
    
    private func openNewsController() {
        let newsVC = NewsViewController(nibName: "News", bundle: nil)
        newsVC.rssItems = self.rssItems
        navigationController?.pushViewController(newsVC, animated: true)
        self.rssItems = nil
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

//
//  FeedParser.swift
//  RSSReader
//
//  Created by zuzex-62 on 29.12.2022.
//

import Foundation

class FeedParser: NSObject, XMLParserDelegate {
    
    private var rssItems = [NewsModel]()
    
    private var currentElement = ""
    
    private var currentTitle = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentLink = "" {
        didSet {
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentDescription = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentImageUrl = "" {
        didSet {
            currentImageUrl = currentImageUrl.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([NewsModel]) -> Void)?
    
    func parseFeed(feedURL: String, completionHandler: (([NewsModel]) -> Void)?) -> Void {
        
        parserCompletionHandler = completionHandler
        
        guard let feedURL = URL(string: feedURL) else {
            print("URL is invalid")
            return
        }
        
        URLSession.shared.dataTask(with: feedURL, completionHandler: { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    print("No data fetched")
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }).resume()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        rssItems.removeAll()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentImageUrl = ""
            currentPubDate = ""
        }
        if currentElement == "enclosure" || currentElement == "media:content" {
            if let url = attributeDict["url"] {
                currentImageUrl += url
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "description":
            currentDescription += string
        case "pubDate":
            currentPubDate += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let newsItem = NewsModel(id: UUID().uuidString, title: currentTitle, link: currentLink, description: currentDescription, imageUrl: currentImageUrl, pubDate: currentPubDate.toDate)
            rssItems.append(newsItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        DispatchQueue.main.async {
            print(parseError.localizedDescription)
        }
    }
}

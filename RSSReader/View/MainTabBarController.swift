//
//  MainTabBarController.swift
//  RSSReader
//
//  Created by zuzex-62 on 11.01.2023.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var rssDataSource: [NewsModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        for viewController in self.viewControllers ?? [] {
            if let navigationVC = viewController as? UINavigationController, let rootVC = navigationVC.viewControllers.first {
                let _ = rootVC.view
            } else {
                let _ = viewController.view
            }
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if let nvc = viewController as? UINavigationController, Reachability.isConnectedToNetwork() {
//            if let newsVC = nvc.viewControllers.first as? NewsViewController {
//                newsVC.setData(items: rssDataSource)
//            }
//        }
    }
    
}

//
//  SpinnerViewController.swift
//  RSSReader
//
//  Created by zuzex-62 on 09.01.2023.
//

import UIKit

class SpinnerView: UIView {
    
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override init(frame: CGRect) {
    super.init(frame: frame)
      setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    //common func to init our view
    private func setupView() {
        if let inputView {
            inputView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            inputView.addSubview(spinner)
            
            spinner.centerXAnchor.constraint(equalTo: inputView.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: inputView.centerYAnchor).isActive = true
        }
    }
    
}

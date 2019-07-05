//
//  ViewController.swift
//  AppleFrameworkRemake
//
//  Created by Cuong Vuong on 12/6/19.
//  Copyright © 2019 Cuong Vuong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrView = UIScrollView(frame: CGRect(x: 100, y: 000, width: 300, height: 300))
        scrView.backgroundColor = .red
        scrView.contentSize = CGSize(width: 600, height: 600)
        scrView.delegate = self

        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        subview.backgroundColor = .blue
        scrView.addSubview(subview)
        
        let scrView2 = CVScrollView(frame: CGRect(x: 100, y: 400, width: 300, height: 300))
        scrView2.backgroundColor = .red
        scrView2.contentSize = CGSize(width: 600, height: 600)
        
        let subview2 = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        subview2.backgroundColor = .yellow
        scrView2.addSubview(subview2)
        
        view.addSubview(scrView)
        view.addSubview(scrView2)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}

//
//  DetailsViewController.swift
//  TestTask
//
//  Created by Dmitry Soldatenko on 4/4/18.
//  Copyright © 2018 Dmitry Soldatenko. All rights reserved.
//

import UIKit
import Foundation
import FeedKit

class DetailsViewController : UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var feedItem: RSSFeedItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = feedItem?.title
        self.textView.text = feedItem?.description?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}

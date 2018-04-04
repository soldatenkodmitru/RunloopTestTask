//
//  MainViewController.swift
//  TestTask
//
//  Created by Dmitry Soldatenko on 4/4/18.
//  Copyright © 2018 Dmitry Soldatenko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var feedLabel: UILabel!
    
    var timer = Timer()
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy  HH:mm:ss"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "Dima Soldatenko";
        feedLabel.text = "";
        NotificationCenter.default.addObserver(self, selector: #selector(self.feedChanged(notification:)), name: Notification.Name("feedChanged"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let current = Date()
        timeLabel.text = formatter.string(from: current)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getTime), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    

    @objc func getTime() {
        let current = Date()
        timeLabel.text = formatter.string(from: current)
    }
    
    @objc func feedChanged(notification: Notification){
        if let text = notification.userInfo?["title"] as? String {
            self.feedLabel.text = text
        }
    }
}

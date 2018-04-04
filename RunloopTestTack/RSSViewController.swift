//
//  RSSViewController.swift
//  TestTask
//
//  Created by Dmitry Soldatenko on 4/4/18.
//  Copyright © 2018 Dmitry Soldatenko. All rights reserved.
//

import UIKit
import FeedKit

class RSSViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var timer = Timer()
    var rssFeedParser = RSSFeedParser()
    var businessFeed : RSSFeed?
    var entertainmentFeed : RSSFeed?
    var environmentFeed : RSSFeed?
    var countOfLoadFeed  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        DispatchQueue.main.async {
            self.updateData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateData), userInfo: nil, repeats: true)
         navigationController?.navigationBar.isHidden = true
    }
    
    @objc func segmentChanged() {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return segmentedControl.selectedSegmentIndex == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            switch section
            {
                case 0:
                    return "Entertainment"
                case 1:
                    return "Environment"
                default:
                    return nil
            }
            default:
                return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let feed = getFeedFor(section: section)
        return feed?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rssFeedCell", for: indexPath)
        let feedItem = getFeedItemFor(indexPath: indexPath)
        cell.textLabel?.text = feedItem?.title
        cell.detailTextLabel?.text = feedItem?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedItem = getFeedItemFor(indexPath: indexPath)
        NotificationCenter.default.post(name: NSNotification.Name("selectedFeedChanged"), object: nil, userInfo: ["title" : feedItem?.title as Any])
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsVC.feedItem = feedItem
        show(detailsVC, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
    func getFeedFor(section: Int) -> RSSFeed? {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            return section == 0 ? entertainmentFeed : environmentFeed
        default:
            return businessFeed
        }
    }

    func getFeedItemFor(indexPath: IndexPath) -> RSSFeedItem? {
        let feed = getFeedFor(section: indexPath.section)
        return feed?.items?[indexPath.row]
    }
    
    func loadDataFor(feedType: typeFeed) {
        self.rssFeedParser.getDataFor(typeFeed: feedType, callback: { (feed, error) in
            DispatchQueue.main.async {
                self.countOfLoadFeed += 1
                if self.countOfLoadFeed == 3 {
                    self.activity.stopAnimating()
                }
            
                guard error == nil else {
                    self.showError(error: error!)
                    return
                }
         
                self.setFeed(feedType: feedType, feed: feed)
                self.tableView.reloadData()
            }
        })
    }
    
    func setFeed(feedType: typeFeed , feed: RSSFeed?) {
        switch feedType {
            case .business:
                businessFeed = feed
            case .entertainment:
                entertainmentFeed = feed
            case .environment:
                environmentFeed = feed
        }
    }
    
    @objc func updateData() {
        countOfLoadFeed = 0
        activity.startAnimating()
        loadDataFor(feedType: .business)
        loadDataFor(feedType: .entertainment)
        loadDataFor(feedType: .environment)
    }
    
    func showError(error: Error){
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        present(alert, animated: true, completion: nil)
    
    }
}

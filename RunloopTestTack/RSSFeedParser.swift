//
//  RSSFeed.swift
//  TestTask
//
//  Created by Dmitry Soldatenko on 4/4/18.
//  Copyright © 2018 Dmitry Soldatenko. All rights reserved.
//

import Foundation
import FeedKit

enum typeFeed {
    case entertainment
    case environment
    case business
}

class RSSFeedParser {
    
    let entertainmentURL = URL(string:  "http://feeds.reuters.com/reuters/entertainment")!
    let environmentURL = URL(string: "http://feeds.reuters.com/reuters/environment")!
    let businessURL = URL(string: "http://feeds.reuters.com/reuters/businessNews")!
   
    var feedParser: FeedParser?
    
    func getDataFor(typeFeed: typeFeed, callback: @escaping (RSSFeed?, Error?) -> Void) {
        
        switch typeFeed
        {
            case .entertainment:
                feedParser = FeedParser(URL: entertainmentURL)
            case .environment:
                feedParser = FeedParser(URL: environmentURL)
            case .business:
                feedParser = FeedParser(URL: businessURL)
        }
        
        if feedParser == nil  {
            callback(nil, NSError(domain: "Parser Error", code: 0, userInfo: nil))
            return
        }
        
        feedParser!.parseAsync(result: { (result) in
            switch result
            {
                case let .rss(feed):
                    callback(feed, nil)
                case let .failure(error):
                    callback(nil, error)
                default: break
            }
        })
    }
}

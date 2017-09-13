//
//  DetailViewController.swift
//  OKRoger-v1
//
//  Created by Ash Sharma on 4/4/16.
//  Copyright © 2016 Ash Sharma. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, TWTRTweetViewDelegate {

    
    var detailItem: Airport? {
        didSet {
            // Update the view.
            
            self.configureView()
        }
    }
    
    var tweets = [Tweet]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = false
        self.configureView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tweets.count+1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetcell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetTableViewCell
        if indexPath.row == 0 {
            tweetcell.headerInfo = detailItem
        } else {
            tweetcell.tweet = tweets[indexPath.row-1]
        }
        return tweetcell
    }
}


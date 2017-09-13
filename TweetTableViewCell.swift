//
//  TweetTableViewCell.swift
//
//  Created by Ash Sharma
//  Copyright (c) 2016 Ash Sharma. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    var headerInfo: Airport? {
        didSet {
            updateHeaderCell()
        }
    }
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    
    func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
    //    tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            //print("tweet : ", tweet)
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            let formatter = DateFormatter()
            if Date().timeIntervalSince(tweet.created as Date) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created as Date)
            if tweet.text != nil  {
                let mutableText = NSMutableAttributedString(string: tweet.text, attributes: [ NSForegroundColorAttributeName: UIColor.darkGray])
                
                for ht in tweet.hashtags {
                    mutableText.addAttributes([ NSForegroundColorAttributeName: UIColor.orange], range: ht.nsrange)
                }
                for url in tweet.urls {
                    mutableText.addAttributes([ NSForegroundColorAttributeName: Constants.appleBlueColor], range: url.nsrange)
                }
                for um in tweet.userMentions {
                    mutableText.addAttributes([ NSForegroundColorAttributeName: UIColor.black], range: um.nsrange)
                }
                tweetTextLabel?.attributedText = mutableText
                tweetTextLabel?.sizeToFit()

                if tweet.media.count > 0 {
                    let url = tweet.media[0].url
                    
                    let aratio = tweet.media[0].aspectRatio
                    if aratio > 0 {
                        let scrWidth = tweetImage.bounds.size.width
                        let scrHt = scrWidth/CGFloat(aratio)
                        //print("estimated image width = ",scrWidth)
                        //print("estimated image height = ", scrHt)
                        tweetImage.image = getImageWithColor(UIColor.lightGray, size: CGSize(width: scrWidth, height: scrHt))
                    }
                    
                   // tweetImage.size = CGSizeMake(CGFloat(frame.width), CGFloat(frame.width*tweet.media[0].aspectRatio))
                    let qos = Int(DispatchQoS.QoSClass.userInitiated.rawValue)
                    DispatchQueue.global(priority: qos).async { () -> Void in
                        let imageData = try? Data(contentsOf: url) // this blocks the thread it is on
                        DispatchQueue.main.async {
                            // only do something with this image
                            // if the url we fetched is the current imageURL we want
                            // (that might have changed while we were off fetching this one)
                            if url == tweet.media[0].url { // the variable "url" is capture from above
                                if imageData != nil {
                                    // this might be a waste of time if our MVC is out of action now
                                    // which it might be if someone hit the Back button
                                    // or otherwise removed us from split view or navigation controller
                                    // while we were off fetching the image
                                    self.tweetImage.image = UIImage(data: imageData!)
                                } else {
                                    self.tweetImage.image = nil
                                }
                            }
                        }
                    }

                }
            }
        }

    }
    
    func updateHeaderCell() {
        
        if let hi = headerInfo {
            let wAddress = hi.websiteAddress != "" ? hi.websiteAddress : "N.A."
            let mutableText = NSMutableAttributedString(string: "Website: " + wAddress, attributes: [ NSForegroundColorAttributeName: UIColor.darkGray])
            mutableText.addAttributes([ NSForegroundColorAttributeName: Constants.appleBlueColor], range: NSMakeRange(9, hi.websiteAddress.characters.count))
            tweetTextLabel.attributedText = mutableText
            tweetScreenNameLabel.text = hi.city + ", " + hi.country
            if hi.timezoneOffset > 0 {
                tweetCreatedLabel.text = "UTC+"+String(hi.timezoneOffset)
            } else if hi.timezoneOffset < 0 {
                tweetCreatedLabel.text = "UTC"+String(hi.timezoneOffset)
            } else {
                tweetCreatedLabel.text = ""
            }
        }
    }
    
    func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

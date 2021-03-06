//
//  Whisper.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import Foundation
import SwiftyJSON

class Whisper {
    var content: String!
    var tag: Int!
    var createdAt: NSDate!
    var updatedAt: NSDate!
    var views: Int!
    var facebookId: String!
    var category: String! = ""
    var likesCount: Int!
    var imageURL: NSURL!

    var comments: [Comment]! = [Comment]()

    var truncatedContent: String? {
        var truncated = content as NSString
        if truncated.length > 500 {
            truncated = truncated.substringToIndex(500)
            return (truncated as String).stringByAppendingString("...")
        } else {
            return content
        }
    }

    init(json: JSON) {
        self.tag = json["confession_id"].string?.toInt()
        self.content = json["content"].string
        self.views = json["views"].int
        self.facebookId = json["facebook_information"]["id"].string
        self.likesCount = json["fb_like_count"].string?.toInt()
        if let category = json["categories"].array?.first {
            self.category = category["confession_category"].string
        } else {
            self.category = "no category"
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let createdAtString = json["created_at"].string {
            self.createdAt = dateFormatter.dateFromString(createdAtString)
        }

        if let updatedAtString = json["status_updated_at"].string {
            self.updatedAt = dateFormatter.dateFromString(updatedAtString)
        }

        self.comments = json["facebook_information"]["comments"]["data"].array?.map({
            Comment(json: $0)
        })

        if let url = json["images"].string {
            self.imageURL = NSURL(string: url)
        }
    }
}

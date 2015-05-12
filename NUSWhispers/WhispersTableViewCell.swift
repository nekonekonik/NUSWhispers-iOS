//
//  WhispersTableViewCell.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import KILabel
import SVProgressHUD

class WhispersTableViewCell: UITableViewCell, WhisperRequestManagerDelegate {
    
    @IBOutlet weak var whisperContentAttributedLabel: KILabel!
    @IBOutlet weak var whisperLikesCountLabel: TTTAttributedLabel!
    @IBOutlet weak var whisperTagLabel: UILabel!
    @IBOutlet weak var whisperTimeLabel: UILabel!
    @IBOutlet weak var whisperCategoryLabel: TTTAttributedLabel!
    @IBOutlet weak var whisperCommentsCountLabel: TTTAttributedLabel!
    
    var whispersTableViewController: WhispersTableViewController?
    
    var whisper: Whisper? {
        didSet {
            fillCellContents()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    private func fillCellContents() {
        if let whisper = whisper {
            whisperContentAttributedLabel.text = whisper.truncatedContent!
                .stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceCharacterSet())
            whisperContentAttributedLabel.hashtagLinkTapHandler = WhisperRequestManager.sharedInstance.hashtagLinkTapHandler(self)
            whisperContentAttributedLabel.urlLinkTapHandler = WhisperRequestManager.sharedInstance.urlLinkTapHandler(self)

            whisperTagLabel.text = "#\(whisper.tag!)"
            whisperCategoryLabel.text = whisper.category.lowercaseString
            whisperTimeLabel.text = convertUTCToLocalDateString(whisper.createdAt)
            whisperLikesCountLabel.text = (whisper.likesCount == 1) ? "1 like" : "\(whisper.likesCount) likes"
            whisperCommentsCountLabel.text = (whisper.comments.count == 1) ? "1 comment" : "\(whisper.comments.count) comments"

            contentView.needsUpdateConstraints()
        }
    }
    
    @IBAction func didTapOnViewInFacebookButton(sender: AnyObject) {
        if let facebookPostId = whisper?.facebookId {
            var url: NSURL? = nil
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "fb://")!) {
                // No URL Scheme for page's post yet
                //                url = NSURL(string: "fb://posts/\(facebookPostId)")
            } else {
                //                url = NSURL(string: "https://www.facebook.com/nuswhispers/posts/\(facebookPostId)")
            }
            url = NSURL(string: "https://www.facebook.com/nuswhispers/posts/\(facebookPostId)")
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    func whisperRequestManager(whisperRequestManager: WhisperRequestManager, didReceiveWhispers whispers: [Whisper]) {
        SVProgressHUD.dismiss()
        whispersTableViewController?.hotWhisper = whispers.first
        whispersTableViewController?.performSegueWithIdentifier("showWhisper", sender: self)
    }
    
}

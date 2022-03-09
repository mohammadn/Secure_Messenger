//
//  MessageDetails.swift
//  Secure Instant Messenger
//
//  Created by Mohammad Najafzadeh on 21/10/2021.
//

import Foundation
import UIKit

class MessageDetails: UIViewController {
    
    var selectedMessage : Message?
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var ciphertextLabel: UILabel!
    @IBOutlet var keyLabel: UILabel!
    
    @IBAction func shareText(_ sender: Any) {
        
        let activityViewController = self.shareView(items: [self.ciphertextLabel.text!])
        self.present(activityViewController, animated: true)
        
    }
    
    @IBAction func shareKey(_ sender: Any) {
        
        let activityViewController = self.shareView(items: [self.keyLabel.text!])
        self.present(activityViewController, animated: true)
        
    }
    
    // showing the share extension view
    private func shareView(items: [Any],
                       excludedActivityTypes: [UIActivity.ActivityType]? = nil,
                       ipad: (forIpad: Bool, view: UIView?) = (false, nil)) -> UIActivityViewController {
        
        let activityViewController = UIActivityViewController(activityItems: items,
                                                              applicationActivities: nil)
        if ipad.forIpad {
            activityViewController.popoverPresentationController?.sourceView = ipad.view
        }
        if let excludedActivityTypes = excludedActivityTypes {
            activityViewController.excludedActivityTypes = excludedActivityTypes
        }
        return activityViewController
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.text = selectedMessage?.message
        ciphertextLabel.text = selectedMessage?.ciphertext
        keyLabel.text = selectedMessage?.key
        
    }
    
}

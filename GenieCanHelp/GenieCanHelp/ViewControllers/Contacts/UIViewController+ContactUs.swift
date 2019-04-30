//
//  UIViewController+ContactUs.swift
//  HyperReach
//
//  Created by Macbook Pro on 25/10/2017.
//  Copyright © 2017 Softwareweaver. All rights reserved.
//

import UIKit
import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate
{
    func call(number:String) {
        if let phoneCallURL = URL(string: "tel://\(number)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL)
                }
            }
        }
    }
    
    // MARK: Email Section
    
    func sendEmail(_ email:String, subject : String = "") {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setSubject(subject)
            //mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
 
}

//
//  AboutVC.swift
//  GenieCanHelp
//
//  Created by Test Account on 4/24/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class AboutVC: ParentVC {

    @IBOutlet weak var txtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"
        setContent()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setContent()
    {
        txtView.tintColor = Constants.ThemeColorGreen
        let attributesNormal : [NSAttributedStringKey : Any] = [.font:UIFont(name: Constants.FontAGBookRounded, size: 18)!, .foregroundColor: Constants.ThemeColorPurple]
        
        let attributesUnderlined : [NSAttributedStringKey : Any] = [.font:UIFont(name: Constants.FontAGBookRounded, size: 18)!, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue, .foregroundColor: Constants.ThemeColorGreen]
        
        let attributedString = NSMutableAttributedString(string: "GenieCanHelp is developed by CyberGenie Solutions.\n\nCyberGenie Solutions is an App development business. We have a mission to:\n\nDevelop most interesting and reliable software solutions, services and applications. Do research and product development in latest technologies.\n\nFor details visit:\n", attributes: attributesNormal)
        
        
        attributedString.append(NSAttributedString(string: "http://cybergeniesolutions.com/", attributes: attributesUnderlined))
    
        txtView.attributedText = attributedString
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

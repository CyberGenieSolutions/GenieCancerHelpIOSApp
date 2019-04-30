//
//  TermsAndConditionsVC.swift
//  GenieCanHelp
//
//  Created by Test Account on 4/24/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: ParentVC {

    @IBOutlet weak var txtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Terms and Conditions"
        // Do any additional setup after loading the view.
        setContent()
//        UIFont.familyNames.forEach({ familyName in
//            let fontNames = UIFont.fontNames(forFamilyName: familyName)
//            print(familyName, fontNames)
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setContent()
    {
        
        let attributesNormal : [NSAttributedStringKey : Any] = [.font:UIFont(name: "AGBookRounded-Regular", size: 18)!, .foregroundColor: Constants.ThemeColorPurple]
        
        let attributesBold : [NSAttributedStringKey : Any] = [.font:UIFont(name: "AGBookRounded-Medium", size: 18)!, .foregroundColor: Constants.ThemeColorPurple]
        
        let attributedString = NSMutableAttributedString(string: "This App is developed and operated by CyberGenie Solutions. CyberGenie Solutions reserves the right to amend the Terms and Conditions at any time without notice.\n\n", attributes: attributesNormal)
        
        attributedString.append(NSMutableAttributedString(string: "Parties\n\n", attributes: attributesBold))
        
        attributedString.append(NSMutableAttributedString(string: "This Agreement is between you and CyberGenie Solutions only, and not Apple. Notwithstanding the foregoing, you acknowledge that Apple and its subsidiaries are third party beneficiaries of this Agreement and Apple has the right to enforce this Agreement against you. CyberGenie Solutions, not Apple, is solely responsible for the GenieCanHelp App and its content.\n\n", attributes: attributesNormal))
        
        attributedString.append(NSMutableAttributedString(string: "Privacy\n\n", attributes: attributesBold))
        
        attributedString.append(NSMutableAttributedString(string: "CyberGenie Solutions may collect and use information about your usage of the GenieCanHelp App, including certain types of information from and about your device. CyberGenie Solutions may use this information, as long as it is in a form that does not personally identify you, to measure the use and performance of the App.\n\n", attributes: attributesNormal))
        
        
        attributedString.append(NSMutableAttributedString(string: "Limited License\n\n", attributes: attributesBold))
        
        attributedString.append(NSMutableAttributedString(string: "CyberGenie Solutions grants you a limited, non-exclusive, non-transferable, revocable license to use the GenieCanHelp App for your personal, non-commercial purposes. You may only use the App on iOS devices that you own or control and as permitted by the App Store Terms of Service.\n\n", attributes: attributesNormal))
        
        
        attributedString.append(NSMutableAttributedString(string: "Copyright\n\n", attributes: attributesBold))
        
        attributedString.append(NSMutableAttributedString(string: "All rights are reserved. CyberGenie Solutions is the legal and moral owner of the copyright and other intellectual property subsisting in this App and the material published on this App may not be copied, distributed, downloaded, modified, printed, reposted or transmitted in any way for commercial or any other use without the written consent of CyberGenie Solutions.\n\n", attributes: attributesNormal))
        
        
        attributedString.append(NSMutableAttributedString(string: "Disclaimer\n\n", attributes: attributesBold))
        
        attributedString.append(NSMutableAttributedString(string: "CyberGenie Solutions and its directors, officers and employees make no warranties as to accuracy, reliability, completeness or otherwise of the data and other information on the App or generated using the App. Whilst CyberGenie Solutions sincerely aims at ensuring that all information and calculations on the App are current and accurate. The App may contain some errors and inaccuracies.\n\n", attributes: attributesNormal))
        
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

//
//  Common.swift
//  GenieCanHelp
//
//  Created by Test Account on 4/11/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class Common: NSObject {

    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static func buildVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        //let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return build
    }
}

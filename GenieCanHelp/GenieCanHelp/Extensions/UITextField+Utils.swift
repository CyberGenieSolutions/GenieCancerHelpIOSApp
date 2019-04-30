//
//  UITextField+Utils.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/21/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

extension UITextField
{
    func setLeftPadding(_ amount:CGFloat = 5){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPadding(_ amount:CGFloat = 5) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

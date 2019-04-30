//
//  String+Utils.swift
//  Qserv
//
//  Created by Shehzad on 4/1/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import Foundation

extension String
{
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func encode() -> String! {
        
        let encodedString = self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        return encodedString
    }
    
    func getDate(format: String? = "dd-MM-yyyy", timeZone:TimeZone = TimeZone.current) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        
        let date = formatter.date(from: self)
        
        return date
    }
    
    func removingControlCharacters() -> String {
        let controlChars = NSCharacterSet.controlCharacters
        var range = self.rangeOfCharacter(from: controlChars)
        var mutable = self
        while let removeRange = range {
            mutable.removeSubrange(removeRange)
            range = mutable.rangeOfCharacter(from: controlChars)
        }
        
        return mutable
    }
    
    func validateForEmail() -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
        
    }
}

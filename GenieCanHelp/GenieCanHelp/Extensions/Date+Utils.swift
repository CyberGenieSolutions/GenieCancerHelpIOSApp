//
//  Date+Utils.swift
//  Qserv
//
//  Created by Shehzad on 4/1/18.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

extension Date
{
    func getDateTimeString(inFormat: String? = "dd-MM-yyyy", timeZone:TimeZone = TimeZone.current) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = inFormat
        formatter.locale = Locale(identifier: "en")
        formatter.timeZone = timeZone
        let dateString = formatter.string(from: self)
        
        return dateString
    }
    
    func addSeconds(_ seconds: Int) -> Date! {
        
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .second, value: seconds, to: self)
        
        return newDate!
    }
    
    func addMinutes(_ minutes: Int) -> Date! {
        
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: minutes, to: self)
        
        return newDate!
    }
    
    func addHours(_ hours: Int) -> Date! {
        
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .hour, value: hours, to: self)
        
        return newDate!
    }
    
    func addDays(_ days: Int) -> Date! {
        
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: days, to: self)
        
        return newDate!
    }
    
    func addYears(_ years: Int) -> Date! {
        
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .year, value: years, to: self)
        
        return newDate!
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter.string(from: self)
        // or use capitalized(with: locale) if you want
    }
    
    var startOfDay : Date {
        let calendar = Calendar.current
        //calendar.timeZone = Constants.UTCTimeZone!
        let unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components)!
    }
    
    var endOfDay : Date {
        let calendar = Calendar.current
        //calendar.timeZone = Constants.UTCTimeZone!
        var components = DateComponents()
        components.day = 1
        let date = calendar.date(byAdding: components, to: self.startOfDay)
        return (date?.addingTimeInterval(-1))!
    }
}

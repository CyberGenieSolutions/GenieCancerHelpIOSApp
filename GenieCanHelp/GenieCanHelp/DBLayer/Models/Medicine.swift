//
//  Medicine.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/5/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import RealmSwift

class Medicine: Object
{
    @objc dynamic var medicineName : String?
    @objc dynamic var unit : String?
    @objc dynamic var instructions : String?
    @objc dynamic var startDate : Date?
    @objc dynamic var endDate : Date?
    @objc dynamic var days : Week?
    public var medicineTimes = List<MedicineTime>()
    
    override static func primaryKey() -> String? {
        return "medicineName"
    }
}

class Week: Object
{
    @objc dynamic var saturday: Bool = false
    @objc dynamic var sunday: Bool = false
    @objc dynamic var monday: Bool = false
    @objc dynamic var tuesday: Bool = false
    @objc dynamic var wednesday: Bool = false
    @objc dynamic var thursday: Bool = false
    @objc dynamic var friday: Bool = false
}

class MedicineTime: Object
{
    public var reminderIdentifiers = List<String>()
    @objc dynamic var noOfDozes : Int = 1
    @objc dynamic var time : String = "08:00 AM"
}

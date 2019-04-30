//
//  Profile.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/3/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import RealmSwift

class Profile: Object {

    @objc dynamic var pk: Int = 1
    @objc dynamic var patientName: String?
    @objc dynamic var dateOfBirth: Date?
    @objc dynamic var height: String?
    @objc dynamic var weight: String?
    
    @objc dynamic var surfaceArea: String?
    @objc dynamic var bmi: String?
    @objc dynamic var parentName: String?
    
    @objc dynamic var phoneNumber: String?
    @objc dynamic var email: String?
    @objc dynamic var street: String?
    @objc dynamic var suburb: String?
    @objc dynamic var state: String?
    @objc dynamic var postalCode: String?
    
    override static func primaryKey() -> String? {
        return "pk"
    }
}

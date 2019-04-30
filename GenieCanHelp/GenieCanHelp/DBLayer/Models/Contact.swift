//
//  Contact.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/4/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit
import RealmSwift

class Contact: Object {

    @objc dynamic var contactName: String?
    @objc dynamic var phoneNumber: String?
    @objc dynamic var email: String?
    @objc dynamic var street: String?
    @objc dynamic var suburb: String?
    @objc dynamic var state: String?
    @objc dynamic var postalCode: String?
    
    override static func primaryKey() -> String? {
        return "contactName"
    }
    
    
}

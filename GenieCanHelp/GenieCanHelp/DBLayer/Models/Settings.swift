//
//  Settings.swift
//  GenieCanHelp
//
//  Created by Test Account on 4/22/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import RealmSwift

class Settings: Object
{
    @objc dynamic var appointmentReminder : Bool = true
    @objc dynamic var medicineReminder : Bool = true
}

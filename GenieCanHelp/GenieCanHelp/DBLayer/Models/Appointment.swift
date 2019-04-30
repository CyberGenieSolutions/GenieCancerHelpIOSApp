//
//  Appointment.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/6/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import RealmSwift

class Appointment: Object
{
    @objc dynamic var reminderIdentifier: String?
    @objc dynamic var appointmentWith: String?
    @objc dynamic var location: String?
    @objc dynamic var time: Date?
}

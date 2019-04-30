//
//  BodyTemperature.swift
//  GenieCanHelp
//
//  Created by Test Account on 4/30/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import RealmSwift

class BodyTemperature: Object
{
    @objc dynamic var time : Date?
    @objc dynamic var temperature : String?
    @objc dynamic var temperatureUnit : String?
}

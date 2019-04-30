//
//  OxygenLevel.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/30/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import RealmSwift

class OxygenLevel: Object
{
    @objc dynamic var time : Date?
    @objc dynamic var level : String?
}

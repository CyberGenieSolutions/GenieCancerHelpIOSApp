//
//  FluidIntake.swift
//  GenieCanHelp
//
//  Created by Shehzad on 5/3/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import RealmSwift

class FluidIntake: Object
{
    @objc dynamic var time : Date?
    @objc dynamic var unit : String?
    @objc dynamic var quantity : Int = 0
}

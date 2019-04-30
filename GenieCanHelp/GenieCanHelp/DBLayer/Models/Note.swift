//
//  Note.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/18/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import RealmSwift

class Note: Object
{
    @objc dynamic var title : String?
    @objc dynamic var details : String?
}

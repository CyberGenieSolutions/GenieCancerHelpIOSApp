//
//  Mood.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/21/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import RealmSwift

enum MOOD : String
{
    case smile = "Smile"
    case neutral = "Neutral"
    case frown = "Frown"
    
}

class Mood: Object
{
    @objc dynamic var time : Date?
    @objc dynamic var mood : String?
    @objc dynamic var details : String?
}

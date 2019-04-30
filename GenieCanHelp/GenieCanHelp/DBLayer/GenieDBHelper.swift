//
//  GenieDBHelper.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/22/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class GenieDBHelper
{
    static func getSettings() -> Settings
    {
        var settings : Settings!
        if let options = RealmHelper.objects(type: Settings.self), (options.count > 0)
        {
            settings = options.first
        }
        else
        {
            settings = Settings()
            RealmHelper.addObject(settings, update: false)
        }
        
        return settings
    }
}

//
//  MyList.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/19/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import RealmSwift

class MyList: Object
{
    @objc dynamic var title : String?
    public var items = List<String>()
    
    class func fromDictionary(dictionary: [String:Any]) -> MyList    {
        let this = MyList()
        if let title = dictionary["title"] as? String{
            this.title = title
        }
        let items = dictionary["items"] as? [String]
        this.items.append(objectsIn: items!)
        
        
        return this
    }
}

//
//  RealmHelper.swift
//  Qserv
//
//  Created by Shehzad on 4/1/18.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit
import RealmSwift


extension Results {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}


class RealmHelper {
    
    static func setConfiguration()
    {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                
                if oldSchemaVersion < 1 {
//                    migration.enumerate(WorkoutSet.className()) { oldObject, newObject in
//                        newObject?["setCount"] = setCount
//                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    static func updateContext(_ block: (() -> Void)) {
        do {
            let realm = try Realm()
            try realm.write {
                
                block()
            }
        } catch let error as NSError {
            //TODO: Handle error
            print(error.localizedDescription)
        }
    }
    
    static func objects<T: Object>(type: T.Type) -> Results<T>? {
        let realm = try? Realm()
        
        return realm?.objects(type)
    }
    
    static func addObject<T: Object>(_ object : T, update:Bool = true)
    {
        do {
            let realm = try Realm()
            try realm.write {
                
                realm.add(object,update: update)
                
            }
        } catch let error as NSError {
            //TODO: Handle error
            print(error.localizedDescription)
        }
    }
    
    static func addObjects<T: Object>(_ objects : [T], update:Bool = true)
    {
        do {
            let realm = try Realm()
            try realm.write {
                for object in objects {
                    realm.add(object,update: update)
                }
            }
        } catch let error as NSError {
            //TODO: Handle error
            print(error.localizedDescription)

        }
    }
    
    static func deleteObject<T: Object>(_ object : T)
    {
        do {
            let realm = try Realm()
            try realm.write {
                
                realm.delete(object)
            }
            
            
        } catch let error as NSError {
            //TODO: Handle error
            print(error.localizedDescription)
            
        }
    }
    
    static func deleteObjects<S: Sequence>(_ objects: S) where S.Iterator.Element: Object
    {
        do {
            let realm = try Realm()
            try realm.write {
                
                realm.delete(objects)
            }
            
            
        } catch let error as NSError {
            //TODO: Handle error
            print(error.localizedDescription)
            
        }
    }
    
    static func deleteObjectsOf<T: Object>(type: T.Type)
    {
        do {
            let realm = try Realm()
            try realm.write {
                
                realm.delete(realm.objects(type))
            }
            
            
        } catch let error as NSError {
            //TODO: Handle error
            print(error.localizedDescription)
            
        }
    }
}

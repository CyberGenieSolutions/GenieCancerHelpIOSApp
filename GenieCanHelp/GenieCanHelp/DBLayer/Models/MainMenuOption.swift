//
//	MainMenuOption.swift
//
//	Create by Shehzad on 1/4/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import RealmSwift

enum OptionName:String {
    case PROFILE        = "PROFILE"
    case CONTACTS       = "CONTACTS"
    case MEDICATIONS    = "MEDICATIONS"
    case APPOINTMENTS   = "APPOINTMENTS"
    case NOTES_TO_KEEP  = "NOTES TO KEEP"
    case MOOD_TRACKER   = "MOOD TRACKER"
    case BODY_TEMPERATURE = "BODY TEMPERATURE"
    case OXYGEN_LEVEL   = "OXYGEN LEVEL"
    case USEFUL_LINKS   = "USEFUL LINKS"
    case MY_LISTS       = "MY LISTS"
    case FLUID_INTAKE   = "FLUID INTAKE"
}

class MainMenuOption: Object
{

    @objc dynamic var isVisible: Bool = false
    @objc dynamic var optionImageName: String?
    @objc dynamic var optionName: String?
    
    override static func primaryKey() -> String? {
        return "optionName"
    }
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	class func fromDictionary(dictionary: [String:Any]) -> MainMenuOption	{
		let this = MainMenuOption()
		if let isVisibleValue = dictionary["is_visible"] as? Bool{
			this.isVisible = isVisibleValue
		}
		if let optionImageNameValue = dictionary["option_image_name"] as? String{
			this.optionImageName = optionImageNameValue
		}
		if let optionNameValue = dictionary["option_name"] as? String{
			this.optionName = optionNameValue
		}
		return this
	}

}

//
//  MainMenuSettingCell.swift
//  GenieCanHelp
//
//  Created by Shehzad on 5/4/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class MainMenuSettingCell: UICollectionViewCell {

    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var lblOptionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private var option : MainMenuOption!
    
    
    func updateCellWithOption(_ option: MainMenuOption)
    {
        self.option = option
        lblOptionName.text = option.optionName
        `switch`.isOn = option.isVisible
    }

    @IBAction func onChange(_ sender: UISwitch) {
        
        RealmHelper.updateContext {
            self.option.isVisible = sender.isOn
        }
    }
}

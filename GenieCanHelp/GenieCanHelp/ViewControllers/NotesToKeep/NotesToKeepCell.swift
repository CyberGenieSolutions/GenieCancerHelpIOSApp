//
//  NotesToKeepCell.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/18/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class NotesToKeepCell: UITableViewCell {

    @IBOutlet weak var lblNoteTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellWithNote(_ note :Note)
    {
        lblNoteTitle.text = note.title
    }
    
}

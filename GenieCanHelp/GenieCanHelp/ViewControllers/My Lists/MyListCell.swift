//
//  MyListCell.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/19/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class MyListCell: UITableViewCell {

    @IBOutlet weak var lblListTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCellWithList(_ list :MyList)
    {
        lblListTitle.text = (list.title == "") ? "[No Title]" : list.title
        
    }
    
}

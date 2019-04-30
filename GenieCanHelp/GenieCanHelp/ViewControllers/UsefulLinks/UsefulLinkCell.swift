//
//  UsefulLinkCell.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/19/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class UsefulLinkCell: UITableViewCell {

    @IBOutlet weak var txtViewLink: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellWithLink(_ link :UsefulLink)
    {
        lblTitle.text = link.title
        
        let attributes : [NSAttributedStringKey : Any] = [.font:txtViewLink.font!, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let attrubutesString = NSAttributedString(string: link.link, attributes: attributes)
        txtViewLink.attributedText = attrubutesString
    }
    
}

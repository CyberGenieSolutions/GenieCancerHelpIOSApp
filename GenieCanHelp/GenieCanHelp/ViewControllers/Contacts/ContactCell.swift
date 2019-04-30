//
//  ContactCell.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/4/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell
{

    //MARK: - Properties
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    //MARK: - Life Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - Public Methods
    
    func updateCellWithContact(_ contact:Contact)
    {
        lblName.text = contact.contactName
        lblPhoneNo.text = contact.phoneNumber
        lblEmail.text = contact.email
        
        var address = (contact.street) ?? ""
        
        if let suburb = contact.suburb, suburb != ""
        {
            address += " " + suburb
        }
        
        if let state = contact.state, state != ""
        {
            address += " " + state
        }
        
        if let postalCode = contact.postalCode, postalCode != ""
        {
            address += " " + postalCode
        }
        
        lblAddress.text = address
    }
    
}

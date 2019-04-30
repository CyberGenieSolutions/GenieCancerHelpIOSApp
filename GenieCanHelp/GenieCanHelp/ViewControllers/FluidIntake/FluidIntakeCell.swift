//
//  FluidIntakeCell.swift
//  GenieCanHelp
//
//  Created by Shehzad on 5/3/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class FluidIntakeCell: UITableViewCell {

    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellWithRecord(_ record : FluidIntake)
    {
        lblTime.text = record.time?.getDateTimeString(inFormat: "EEEE  dd-MM-yyyy")
        lblDetails.text = "\(record.quantity) \(record.unit ?? "")"
        if record.unit == "cup" && record.quantity > 1
        {
            lblDetails.text?.append("s")
        }
    }
    
}

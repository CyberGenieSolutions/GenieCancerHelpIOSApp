//
//  MedicineDoseTimeCell.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/6/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class MedicineDoseTimeCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDose: UILabel!
    
    //MARK: - Life Cycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCellWithTime(time:MedicineTime)
    {
        lblTime.text = time.time
        lblDose.text = "take \(time.noOfDozes) dose"
        if time.noOfDozes > 1
        {
            lblDose.text?.append("s")
        }
    }
    
}

//
//  TemperatureRecordCell.swift
//  GenieCanHelp
//
//  Created by Test Account on 4/30/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class TemperatureRecordCell: UITableViewCell {

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
    
    func updateCellWithRecord(_ record : BodyTemperature)
    {
        lblTime.text = record.time?.getDateTimeString(inFormat: "EEEE  dd-MM-yyyy hh:mm a")
        lblDetails.text = record.temperature! + " ˚" +  record.temperatureUnit!
    }
    
}

//
//  MoodTrackerCell.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/21/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class MoodTrackerCell: UITableViewCell {

    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgMood: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellWithMood(_ mood : Mood)
    {
        lblTime.text = mood.time?.getDateTimeString(inFormat: "EEEE  dd-MM-yyyy hh:mm a")
        lblDetails.text = mood.details
        imgMood.image = UIImage(named:mood.mood ?? "")
    }
    
}

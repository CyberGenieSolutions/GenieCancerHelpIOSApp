//
//  AppointmentCell.swift
//  GenieCanHelp
//
//  Created by Test Account on 4/6/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {

    @IBOutlet weak var lblWith: UILabel!
    @IBOutlet weak var lblWhere: UILabel!
    @IBOutlet weak var lblWhen: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Public Methods
    
    func updateCellWithAppointment(_ appointment:Appointment)
    {
        lblWith.text = appointment.appointmentWith
        lblWhere.text = appointment.location
        lblWhen.text = appointment.time?.getDateTimeString(inFormat: "dd-MM-yyyy hh:mm a")
    }
    
}

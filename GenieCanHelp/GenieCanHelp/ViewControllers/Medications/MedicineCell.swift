//
//  MedicineCell.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/5/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class MedicineCell: UITableViewCell {

    @IBOutlet weak var lblMedicineName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCellWithMedicine(_ medicine :Medicine)
    {
        lblMedicineName.text = medicine.medicineName
    }
    
}

//
//  MainMenuCell.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/1/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class MainMenuCell: UICollectionViewCell
{
    //MARK: - Properties
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    
    //MARK: - Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderColor = Constants.ThemeColorGray.cgColor
        containerView.layer.borderWidth = 0.5
        
    }
    
    //MARK: - Public Methods
    func updateCellWithItem(item:MainMenuOption)
    {
        lblItemName.text = item.optionName
        imgItem.image = UIImage(named:item.optionImageName!)
        
    }
}

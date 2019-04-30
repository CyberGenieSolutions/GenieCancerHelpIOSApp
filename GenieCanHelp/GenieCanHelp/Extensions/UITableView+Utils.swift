//
//  UITableView+Utils.swift
//  Qserv
//
//  Created by Macbook Pro on 21/11/2017.
//  Copyright © 2017 Mobdev125. All rights reserved.
//

import UIKit

extension UITableView {

    func registerNib(with identifier:String!)
    {
        let nib = UINib(nibName: identifier, bundle: Bundle.main)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
}

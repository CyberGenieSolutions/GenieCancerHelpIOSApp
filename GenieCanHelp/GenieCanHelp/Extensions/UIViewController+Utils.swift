//
//  UIViewController+Utils.swift
//  QServ
//
//  Created by Shehzad on 4/1/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import Foundation
import UIKit


enum AlertAction {
    case eAlertActionCancel
    case eAlertActionOK
}

enum ActionSheetOption :String {
    case eActionSheetOptionCancel = "Cancel"
    case eActionSheetOptionEdit = "Edit"
    case eActionSheetOptionDelete = "Delete"
    case eActionSheetOptionCall = "Call"
    case eActionSheetOptionEmail = "Email"
    
}

extension UIViewController
{
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu")!)
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        //self.slideMenuController()?.removeRightGestures()
    }
    
    func showAlert(title: String? = Constants.AppName, message: String, leftButtonTitle: String? = "OK".localized(), rightButtonTitle: String? = nil, completion: ((AlertAction)->Void)? = nil)
    {
        
        let alertController = UIAlertController(title: title, message: "\n\(message)", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: leftButtonTitle, style: .default) { (action) in
            
            if let handler = completion
            {
                handler(.eAlertActionCancel)
            }
            
        }
        
        alertController.addAction(alertAction)
        
        if let _ = rightButtonTitle
        {
            let rightAlertAction = UIAlertAction(title: rightButtonTitle, style: .default) { (action) in
                
                if let handler = completion
                {
                    handler(.eAlertActionOK)
                }
                
            }
            alertController.addAction(rightAlertAction)
        }
        
        
        
        
        self.present(alertController, animated: true){
            
        }
    }
    

    
    func showActionSheet(title: String?, message: String? = nil, cancelButtonTitle: String? = "Cancel".localized(), otherOptions: [ActionSheetOption]? = nil, completion: ((ActionSheetOption)->Void)? = nil)
    {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        if let _ = otherOptions
        {
            for option in otherOptions!
            {
                let action = UIAlertAction(title: option.rawValue, style: .default) { (action) in
                    
                    if let handler = completion
                    {
                        handler(option)
                    }
                    
                }
                alertController.addAction(action)
            }
            
        }
        
        let alertAction = UIAlertAction(title: cancelButtonTitle, style: .destructive) { (action) in
            
            if let handler = completion
            {
                handler(.eActionSheetOptionCancel)
            }
            
        }
        alertController.addAction(alertAction)
        
        self.present(alertController, animated: true){
            
        }
    }
    
    func setBackBarButton() {
        let buttonImage = UIImage(named:"ic_back")
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: buttonImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.onClick_back))
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func onClick_back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

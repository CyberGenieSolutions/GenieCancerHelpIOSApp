//
//  ParentVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/4/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class ParentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBarButton()
        
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsHelper.trackScreen(self.title ?? "", className: classForCoder.description())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

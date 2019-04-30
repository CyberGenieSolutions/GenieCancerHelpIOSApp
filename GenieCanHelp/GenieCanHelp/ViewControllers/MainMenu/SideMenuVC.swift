//
//  SideMenuVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/1/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit
import SafariServices

class SideMenuVC: UIViewController, SFSafariViewControllerDelegate
{

    @IBOutlet weak var tableView: UITableView!
        {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    var mainMenuVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(with: "LeftMenuCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsHelper.trackScreen("Left Menu", className: classForCoder.description())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Private Methods
extension SideMenuVC
{
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    func shareApp()
    {
        let text = Constants.ShareText
        //let url = URL(string: "http://geniecanhelpapp.com/")
        let textShare : [AnyObject] = [text as AnyObject ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func openFeedbackPage()
    {
        let urlString = "https://www.surveymonkey.com/r/3YN6KWC"
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
}

//MARK: - UITableViewDelegate
extension SideMenuVC : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section == 1
        {
            return "Communicate"
        }

        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell", for: indexPath) as! LeftMenuCell
        
        
        if indexPath.section == 0
        {
            switch indexPath.row {
            case 0:
                cell.lblTitle.text = "Terms and Conditions"
                cell.imgIcon.image = #imageLiteral(resourceName: "menu_tandc")
                break
            case 1:
                cell.lblTitle.text = "About"
                cell.imgIcon.image = #imageLiteral(resourceName: "menu_about")
                break
            case 2:
                cell.lblTitle.text = "Settings"
                cell.imgIcon.image = #imageLiteral(resourceName: "menu_setting")
                break
            default:
                break
            }
        }
        else
        {
            switch indexPath.row {
            case 0:
                cell.lblTitle.text = "Share"
                cell.imgIcon.image = #imageLiteral(resourceName: "share")
                break
            case 1:
                cell.lblTitle.text = "Rate Us"
                cell.imgIcon.image = #imageLiteral(resourceName: "menu_star")
                break
            case 2:
                cell.lblTitle.text = "Feedback"
                cell.imgIcon.image = #imageLiteral(resourceName: "send")
                break
            case 3:
                cell.lblTitle.text = "Report a bug"
                cell.imgIcon.image = #imageLiteral(resourceName: "menu_bug")
                break
            default:
                break
            }
        }
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 3
        }
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


//MARK: - UITableViewDataSource
extension SideMenuVC : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.section == 0
        {
            switch indexPath.row {
            case 0:
                //cell.lblTitle.text = "Terms and Conditions"
                self.closeLeft()
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "TermsAndConditionsVC")
                (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(destination!, animated: true)
                break
            case 1:
                //cell.lblTitle.text = "About"
                self.closeLeft()
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "AboutVC")
                (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(destination!, animated: true)
                break
            case 2:
                //cell.lblTitle.text = "Settings"
                self.closeLeft()
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC")
                (self.slideMenuController()?.mainViewController as! UINavigationController).pushViewController(destination!, animated: true)
                break
            default:
                break
            }
        }
        else
        {
            switch indexPath.row {
            case 0:
                //cell.lblTitle.text = "Share"
                shareApp()
                break
            case 1:
                //cell.lblTitle.text = "Rate Us"
                rateApp(appId: Constants.AppStoreAppId) { (result) in
                    
                }
                break
            case 2:
                //cell.lblTitle.text = "Feedback"
                openFeedbackPage()
                
                break
            case 3:
                //cell.lblTitle.text = "Report a bug"
                self.sendEmail("support@cybergeniesolutions.com", subject: "GenieCanHelp iPhone app bug report")
                break
            default:
                break
            }
        }
    }
}

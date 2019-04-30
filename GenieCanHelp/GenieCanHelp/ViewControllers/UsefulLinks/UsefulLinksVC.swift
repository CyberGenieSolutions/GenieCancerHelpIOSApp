//
//  UsefulLinksVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/19/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit


class UsefulLink : NSObject
{
    var title : String!
    var link  : String!
    
    required init(title : String!, link:String!) {
        self.title = title
        self.link = link
    }
    
}

class UsefulLinksVC: ParentVC {

    
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
        {
        didSet{
            //tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    private var usefulLinks : [UsefulLink] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        makeDataSource()
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


// MARK:- Private Methods
extension UsefulLinksVC
{
    private func setUpUI()
    {
        self.title = "USEFUL LINKS"
        tableView.registerNib(with: "UsefulLinkCell")
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func makeDataSource()
    {
        let link1 = UsefulLink(title: "Download your ‘Cooking for Chemo’ recipe book here", link: "http://www.iconcancercare.com.au/about-us/icc-news/download-cooking-chemo/")
        
        let link2 = UsefulLink(title: "Tasmanian recipes video to offer new dietary ideas for chemotherapy patients", link: "http://www.abc.net.au/news/2017-04-16/video-to-offer-dietary-ideas-for-cancer-patients/8434954")
        
        let link3 = UsefulLink(title: "Cookbooks for Cancer Patients", link: "http://cook-books.com.au/ccp0-catshow/cancer-cookbooks-recipe-books.html")
        
        usefulLinks.append(link1)
        usefulLinks.append(link2)
        usefulLinks.append(link3)
    }
}

// MARK:- UITableViewDataSource
extension UsefulLinksVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return usefulLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsefulLinkCell") as! UsefulLinkCell
        let link = usefulLinks[indexPath.row]
        cell.updateCellWithLink(link)
        
        return cell
    }
}

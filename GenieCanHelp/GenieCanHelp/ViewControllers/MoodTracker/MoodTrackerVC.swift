//
//  MoodTrackerVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/21/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class MoodTrackerVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
        {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var btnMood: UIButton!
    
    private var moods : [Mood] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMoods()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    
    @IBAction func onClick_AddMood(_ sender: UIButton)
    {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddMoodVC") as! EditOrAddMoodVC
        self.navigationController?.pushViewController(destination, animated: true)
        
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
extension MoodTrackerVC
{
    private func setUpUI()
    {
        self.title = "MOOD TRACKER"
        tableView.registerNib(with: "MoodTrackerCell")
        tableView.tableFooterView = UIView()
        btnMood.roundView()
        
        addRightBarButtons()
    }
    
    private func addRightBarButtons()
    {
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.setTitle("Add", for: .normal)
        saveButton.titleLabel?.font = Constants.BarItemFont
        saveButton.addTarget(self, action: #selector(onClick_AddMood(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func getMoods()
    {
        if let tempMoods = RealmHelper.objects(type: Mood.self)
        {
            moods = Array(tempMoods)
            tableView.reloadData()
        }
    }
}

// MARK:- UITableViewDataSource
extension MoodTrackerVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return moods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoodTrackerCell") as! MoodTrackerCell
        let mood = moods[indexPath.row]
        cell.updateCellWithMood(mood)
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension MoodTrackerVC:  UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mood = moods[indexPath.row]
        
        let options : [ActionSheetOption] = [.eActionSheetOptionEdit, .eActionSheetOptionDelete]
        
        self.showActionSheet(title: "", otherOptions: options) { (option) in
            
            switch(option)
            {
            case .eActionSheetOptionEdit:
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddMoodVC") as! EditOrAddMoodVC
                destination.mood = mood
                self.navigationController?.pushViewController(destination, animated: true)
                
                break
                
            case .eActionSheetOptionDelete:
                
                self.moods.remove(at: indexPath.row)
                RealmHelper.deleteObject(mood)
                tableView.reloadData()
                break
                
            default:
                break
            }
        }
    }
}

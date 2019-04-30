//
//  TemperatureRecordsVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/30/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class TemperatureRecordsVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
        {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var btnAdd: UIButton!
    
    private var bodyTempRecords : [BodyTemperature] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getRecords()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    
    @IBAction func onClick_Add(_ sender: UIButton)
    {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddTemperatureRecordVC") as! EditOrAddTemperatureRecordVC
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
extension TemperatureRecordsVC
{
    private func setUpUI()
    {
        self.title = "Temperature Records".uppercased()
        tableView.registerNib(with: "TemperatureRecordCell")
        tableView.tableFooterView = UIView()
        btnAdd.roundView()
        addRightBarButtons()
    }
    
    private func addRightBarButtons()
    {
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.setTitle("Add", for: .normal)
        saveButton.titleLabel?.font = Constants.BarItemFont
        saveButton.addTarget(self, action: #selector(onClick_Add(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func getRecords()
    {
        if let tempRecords = RealmHelper.objects(type: BodyTemperature.self)
        {
            bodyTempRecords = Array(tempRecords)
            tableView.reloadData()
        }
    }
}

// MARK:- UITableViewDataSource
extension TemperatureRecordsVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bodyTempRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemperatureRecordCell") as! TemperatureRecordCell
        let record = bodyTempRecords[indexPath.row]
        cell.updateCellWithRecord(record)
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension TemperatureRecordsVC:  UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let record = bodyTempRecords[indexPath.row]
        
        let options : [ActionSheetOption] = [.eActionSheetOptionEdit, .eActionSheetOptionDelete]
        
        self.showActionSheet(title: "", otherOptions: options) { (option) in
            
            switch(option)
            {
            case .eActionSheetOptionEdit:
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddTemperatureRecordVC") as! EditOrAddTemperatureRecordVC
                destination.record = record
                self.navigationController?.pushViewController(destination, animated: true)
                
                break
                
            case .eActionSheetOptionDelete:
                
                self.bodyTempRecords.remove(at: indexPath.row)
                RealmHelper.deleteObject(record)
                tableView.reloadData()
                break
                
            default:
                break
            }
        }
    }
}

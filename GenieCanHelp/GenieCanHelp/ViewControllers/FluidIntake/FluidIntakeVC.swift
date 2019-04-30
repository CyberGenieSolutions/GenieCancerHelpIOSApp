//
//  FluidIntakeVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 5/3/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class FluidIntakeVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
        {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var btnAdd: UIButton!
    
    private var fluidIntakeRecords : [FluidIntake] = []
    
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
        
        let record = fluidIntakeRecords.first { (record) -> Bool in
            return Calendar.current.isDate(record.time!, inSameDayAs:Date())
        }
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddFuildIntakeVC") as! EditOrAddFuildIntakeVC
        destination.record = record
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
extension FluidIntakeVC
{
    private func setUpUI()
    {
        self.title = "FLUID INTAKE RECORDS"
        tableView.registerNib(with: "FluidIntakeCell")
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
        if let tempRecords = RealmHelper.objects(type: FluidIntake.self)
        {
            fluidIntakeRecords = Array(tempRecords)
            tableView.reloadData()
        }
    }
}

// MARK:- UITableViewDataSource
extension FluidIntakeVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fluidIntakeRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FluidIntakeCell") as! FluidIntakeCell
        let record = fluidIntakeRecords[indexPath.row]
        cell.updateCellWithRecord(record)
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension FluidIntakeVC:  UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let record = fluidIntakeRecords[indexPath.row]
        
        let options : [ActionSheetOption] = [.eActionSheetOptionEdit, .eActionSheetOptionDelete]
        
        self.showActionSheet(title: "", otherOptions: options) { (option) in
            
            switch(option)
            {
            case .eActionSheetOptionEdit:
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddFuildIntakeVC") as! EditOrAddFuildIntakeVC
                destination.record = record
                self.navigationController?.pushViewController(destination, animated: true)
                
                break
                
            case .eActionSheetOptionDelete:
                
                self.fluidIntakeRecords.remove(at: indexPath.row)
                RealmHelper.deleteObject(record)
                tableView.reloadData()
                break
                
            default:
                break
            }
        }
    }
}

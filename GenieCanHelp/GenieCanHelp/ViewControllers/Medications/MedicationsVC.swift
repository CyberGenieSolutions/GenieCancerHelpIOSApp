//
//  MedicationsVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/5/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit
import EventKit

class MedicationsVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var btnAddMedicine: UIButton!
    
    private var medicines : [Medicine] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMedicines()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action Methods
    
    @IBAction func onClick_AddMedicine(_ sender: UIButton)
    {
        
        Common.appDelegate.eventStore.requestAccess(to: .reminder) { (grnated, error) in
            
            DispatchQueue.main.async {
                if grnated
                {
                    let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddMedicineVC") as! EditOrAddMedicineVC
                    self.navigationController?.pushViewController(destination, animated: true)
                }else{
                    
                    self.view.makeToast("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
                }
            }
        }
        
        
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
extension MedicationsVC
{
    private func setUpUI()
    {
        self.title = "MEDICATIONS"
        tableView.registerNib(with: "MedicineCell")
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        btnAddMedicine.roundView()
        addRightBarButtons()
    }
    
    private func addRightBarButtons()
    {
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.setTitle("Add", for: .normal)
        saveButton.titleLabel?.font = Constants.BarItemFont
        saveButton.addTarget(self, action: #selector(onClick_AddMedicine(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func getMedicines()
    {
        if let tempMedicines = RealmHelper.objects(type: Medicine.self)?.reversed()
        {
            medicines = Array(tempMedicines)
            tableView.reloadData()
        }
    }
    
    private func deleteMedicine(_ medicine: Medicine)
    {
        if let days = medicine.days
        {
            RealmHelper.deleteObject(days)
        }
        
        for medicineTime in medicine.medicineTimes
        {
            for identifier in medicineTime.reminderIdentifiers 
            {
                if let reminder = Common.appDelegate.eventStore.calendarItem(withIdentifier: identifier )
                {
                    do {
                        try Common.appDelegate.eventStore.remove(reminder as! EKReminder, commit: true)
                        print("Deleted Reminder : \(reminder.calendarItemIdentifier)")
                    }catch{
                        print("Error creating and saving new reminder : \(error)")
                    }
                }
            }
        }
        
        RealmHelper.deleteObjects(medicine.medicineTimes)
        RealmHelper.deleteObject(medicine)
    }
}

// MARK:- UITableViewDataSource
extension MedicationsVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return medicines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineCell") as! MedicineCell
        let medicine = medicines[indexPath.row]
        cell.updateCellWithMedicine(medicine)
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension MedicationsVC:  UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let medicine = medicines[indexPath.row]
        
        self.showActionSheet(title: "", otherOptions: [.eActionSheetOptionEdit, .eActionSheetOptionDelete]) { (option) in
            
            switch(option)
            {
            case .eActionSheetOptionEdit:
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddMedicineVC") as! EditOrAddMedicineVC
                destination.medicine = medicine
                self.navigationController?.pushViewController(destination, animated: true)
                
                break
                
            case .eActionSheetOptionDelete:
                
                self.medicines.remove(at: indexPath.row)
                self.deleteMedicine(medicine)
                tableView.reloadData()
                break
                
            default:
                break
            }
        }
    }
}

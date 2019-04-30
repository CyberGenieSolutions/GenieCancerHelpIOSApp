//
//  AppointmentsVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/6/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit
import EventKit

class AppointmentsVC: ParentVC {
    
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
        {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var btnAddAppointment: UIButton!
    
    private var appointments : [Appointment] = []
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAppointments()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    
    @IBAction func onClick_AddAppointment(_ sender: UIButton)
    {
        Common.appDelegate.eventStore.requestAccess(to: .reminder) { (grnated, error) in
            
            DispatchQueue.main.async {
                if grnated
                {
                    let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddAppointmentsVC") as! EditOrAddAppointmentsVC
                    self.navigationController?.pushViewController(destination, animated: true)
                }else{
                
                    self.view.makeToast("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
                }
            }
        }
    }

}

// MARK:- Private Methods
extension AppointmentsVC
{
    private func setUpUI()
    {
        self.title = "APPOINTMENTS"
        tableView.registerNib(with: "AppointmentCell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        btnAddAppointment.roundView()
        addRightBarButtons()
    }
    
    private func addRightBarButtons()
    {
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.setTitle("Add", for: .normal)
        saveButton.titleLabel?.font = Constants.BarItemFont
        saveButton.addTarget(self, action: #selector(onClick_AddAppointment(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func getAppointments()
    {
        if let tempAppointments = RealmHelper.objects(type: Appointment.self)
        {
            appointments = Array(tempAppointments)
            tableView.reloadData()
        }
    }
}

// MARK:- UITableViewDataSource
extension AppointmentsVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell") as! AppointmentCell
        let appointment = appointments[indexPath.row]
        cell.updateCellWithAppointment(appointment)
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension AppointmentsVC:  UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appointment = appointments[indexPath.row]
        
        let options : [ActionSheetOption] = [.eActionSheetOptionEdit, .eActionSheetOptionDelete]
        
        self.showActionSheet(title: appointment.appointmentWith, otherOptions: options) { (option) in
            
            switch(option)
            {
            case .eActionSheetOptionEdit:
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddAppointmentsVC") as! EditOrAddAppointmentsVC
                destination.appointment = appointment
                self.navigationController?.pushViewController(destination, animated: true)
                
                break
                
            case .eActionSheetOptionDelete:
                
                self.appointments.remove(at: indexPath.row)
                
                if let reminder = Common.appDelegate.eventStore.calendarItem(withIdentifier: (appointment.reminderIdentifier) ?? "")
                {
                    do {
                        try Common.appDelegate.eventStore.remove(reminder as! EKReminder, commit: true)
                        print("Deleted Reminder : \(reminder.calendarItemIdentifier)")
                    }catch{
                        print("Error creating and saving new reminder : \(error)")
                    }
                }
                
                RealmHelper.deleteObject(appointment)
                tableView.reloadData()
                break
                
            default:
                break
            }
        }
    }
}

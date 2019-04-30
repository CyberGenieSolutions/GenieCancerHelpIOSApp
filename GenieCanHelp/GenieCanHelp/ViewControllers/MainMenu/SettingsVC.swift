//
//  SettingsVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/22/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit
import EventKit

class SettingsVC: ParentVC
{

    //MARK: - Properties
    
    @IBOutlet weak var btnMainMenuSettings: UIButton!
    @IBOutlet weak var switchMedicineReminder: UISwitch!
    @IBOutlet weak var switchAppointmentReminder: UISwitch!
    private var settings : Settings!
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings".uppercased()
        settings = GenieDBHelper.getSettings()
        btnMainMenuSettings.applyShadow()
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Action Methods
    
    @IBAction func onChnage_AppointmentReminder(_ sender: UISwitch) {
        
        RealmHelper.updateContext {
            settings.appointmentReminder = sender.isOn
        }
        
        setAppointmentReminders(on: sender.isOn)
    }
    
    @IBAction func onChnage_MedicineReminder(_ sender: UISwitch) {
        
        RealmHelper.updateContext {
            settings.medicineReminder = sender.isOn
        }
        
        setMedicineReminders(on: sender.isOn)
    }
    
    @IBAction func onClick_MainMenuSettings(_ sender: UIButton) {
        
        
    }
}


//MARK: - Private Methods
extension SettingsVC
{
    private func updateUI()
    {
        switchAppointmentReminder.isOn = settings.appointmentReminder
        switchMedicineReminder.isOn = settings.medicineReminder
    }
    
    private func setAppointmentReminders(on:Bool)
    {
        
        if let appointments = RealmHelper.objects(type: Appointment.self)
        {
            for appointment in appointments
            {
                if let reminder = Common.appDelegate.eventStore.calendarItem(withIdentifier: (appointment.reminderIdentifier) ?? "")
                {
                    do {
                        
                        if on
                        {
                            reminder.alarms?.removeAll()
                            
                            let startDateComponents = (reminder as! EKReminder).startDateComponents
                            let startTime = Calendar.current.date(from: startDateComponents!)
                            let alarm1 = EKAlarm(absoluteDate: startTime!)
                            reminder.addAlarm(alarm1)
                            
                            let dueDateComponents = (reminder as! EKReminder).dueDateComponents
                            let dueTime = Calendar.current.date(from: dueDateComponents!)
                            let alarm2 = EKAlarm(absoluteDate: dueTime!)
                            reminder.addAlarm(alarm2)
                        }
                        else
                        {
                            reminder.alarms?.removeAll()
                        }
                        
                        try Common.appDelegate.eventStore.save(reminder as! EKReminder, commit: true)
                        print("Save Reminder : \(reminder.calendarItemIdentifier)")
                    }catch{
                        print("Error creating and saving new reminder : \(error)")
                    }
                }
            }
        }
    }
    
    private func setMedicineReminders(on:Bool)
    {
        if let medicines = RealmHelper.objects(type: Medicine.self)
        {
            for medicine in medicines
            {
                for medicineTime in medicine.medicineTimes
                {
                    for identifier in medicineTime.reminderIdentifiers
                    {
                        if let reminder = Common.appDelegate.eventStore.calendarItem(withIdentifier: identifier )
                        {
                            do {
                                
                                if on
                                {
                                    reminder.alarms?.removeAll()
                                    let dueDateComponents = (reminder as! EKReminder).dueDateComponents
                                    let reminderTime = Calendar.current.date(from: dueDateComponents!)
                                    let alarm = EKAlarm(absoluteDate: reminderTime!)
                                    reminder.addAlarm(alarm)
                                }
                                else
                                {
                                    reminder.alarms?.removeAll()
                                }
                                
                                try Common.appDelegate.eventStore.save(reminder as! EKReminder, commit: true)
                                print("Saved Reminder : \(reminder.calendarItemIdentifier)")
                            }catch{
                                print("Error creating and saving new reminder : \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
}

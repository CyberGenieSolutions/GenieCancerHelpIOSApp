//
//  EditOrAddAppointmentsVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/6/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit
import EventKit

class EditOrAddAppointmentsVC: ParentVC {

    
    //MARK: - Properties
    
    @IBOutlet weak var txtWith: UITextField!
    @IBOutlet weak var txtWhere: UITextField!
    @IBOutlet weak var txtWhen: APJTextPickerView!
    @IBOutlet weak var btnSave: UIButton!
    var appointment : Appointment?
    private var settings : Settings!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        populateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action Methods
    
    @IBAction func onClick_Save(_ sender: UIButton) {
        
        if txtWith.text?.trim() == ""
        {
            view.makeToast("Please enter \"with\" information for data to be saved")
            return
        }
        
        let appointmentTime = txtWhen.text?.getDate(format: "dd-MM-yyyy hh:mm a")
        
        if appointment?.time != appointmentTime
        {
            if let _ = (RealmHelper.objects(type: Appointment.self)?.first(where: { (appointment) -> Bool in
                return appointment.time == appointmentTime
            }))
            {
                self.showAlert(message: "Appointment with this time already exists. Please choose different time")
                return
            }
        }
        
        if settings.appointmentReminder
        {
            self.showAlert(message: "You will be reminded a day before an appointment.") { (action) in
                
                self.saveAppointment()
                self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            self.saveAppointment()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}

//MARK: - Private Methods
extension EditOrAddAppointmentsVC
{
    private func setUpUI()
    {
        self.title = "APPOINTMENTS"
        txtWhen.datePicker?.minimumDate = Date().addHours(1)
        txtWhen.pickerDelegate = self
        txtWhen.datePicker?.datePickerMode = .dateAndTime
        btnSave.roundView()
        txtWhen.setLeftPadding(10)
        txtWhen.applyShadow()
        settings = GenieDBHelper.getSettings()
        addRightBarButtons()
    }
    
    private func addRightBarButtons()
    {
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = Constants.BarItemFont
        saveButton.addTarget(self, action: #selector(onClick_Save(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func populateUI()
    {
        if appointment != nil
        {
            txtWith.text = appointment?.appointmentWith
            txtWhere.text = appointment?.location
            txtWhen.text = appointment?.time?.getDateTimeString(inFormat: "dd-MM-yyyy hh:mm a")
        }
        else
        {
            txtWhen.text = txtWhen.datePicker?.minimumDate?.getDateTimeString(inFormat: "dd-MM-yyyy hh:mm a")
        }
    }
    
    private func saveAppointment()
    {
        if appointment == nil
        {
            appointment = Appointment()
            let reminder = EKReminder(eventStore: Common.appDelegate.eventStore)
            appointment?.reminderIdentifier = reminder.calendarItemIdentifier
            updateReminder(reminder)
            updateAppointmentObject()
            RealmHelper.addObject(appointment!, update : false)
        
        }
        else
        {
            if let reminder = Common.appDelegate.eventStore.calendarItem(withIdentifier: (appointment?.reminderIdentifier) ?? "")
            {
                updateReminder(reminder as! EKReminder)
            }
            
            RealmHelper.updateContext {
                updateAppointmentObject()
            }
        }
    }
    
    private func updateAppointmentObject()
    {
        let appWith = txtWith.text?.trim()
        let appWhere = txtWhere.text?.trim()
        let appWhen = txtWhen.text?.getDate(format: "dd-MM-yyyy hh:mm a")
   
        appointment?.appointmentWith = appWith
        appointment?.location = appWhere
        appointment?.time = appWhen
    }
    
    private func updateReminder(_ reminder:EKReminder)
    {
        let appWhen = txtWhen.text?.getDate(format: "dd-MM-yyyy hh:mm a")
        
        var reminderTime = appWhen?.addDays(-1)
        
        if reminderTime! < Date()
        {
            reminderTime = Date().addMinutes(1)
        }
        
        reminder.title = "You have an appointment with \(txtWith.text!) at \(txtWhere.text!) at \(txtWhen.text!)"
        let startDateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: reminderTime!)
        reminder.startDateComponents = startDateComponents
        let dueDateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: appWhen!)
        reminder.dueDateComponents = dueDateComponents
        reminder.calendar = Common.appDelegate.eventStore.defaultCalendarForNewReminders()
        
        if settings.appointmentReminder
        {
            let alarm = EKAlarm(absoluteDate: reminderTime!)
            reminder.addAlarm(alarm)
            let alarm2 = EKAlarm(absoluteDate: appWhen!)
            reminder.addAlarm(alarm2)
        }
        
         print("reminder.calendarItemIdentifier : \(reminder.calendarItemIdentifier)")
        // 2
        do {
            try Common.appDelegate.eventStore.save(reminder, commit: true)
            print("reminder.calendarItemIdentifier : \(reminder.calendarItemIdentifier)")
        }catch{
            print("Error creating and saving new reminder : \(error)")
        }
    }
    
}

//MARK:- APJTextPickerViewDelegate
extension EditOrAddAppointmentsVC: APJTextPickerViewDelegate
{
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectDate date: Date) {
        print("Date Selected: \(date)")
        txtWhen.text = date.getDateTimeString(inFormat: "dd-MM-yyyy hh:mm a")
        
    }
    
    //    func textPickerView(_ textPickerView: APJTextPickerView, didSelectString row: Int) {
    //        print("City Selected: \(strings[row])")
    //        txtGender.text = strings[row]
    //    }
    //
    //    func textPickerView(_ textPickerView: APJTextPickerView, titleForRow row: Int) -> String? {
    //        //txtGender.text = strings[row]
    //        return strings[row]
    //    }
}

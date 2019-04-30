//
//  EditOrAddMedicineVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/5/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit
import EventKit
import RealmSwift

enum TextFieldTag : Int
{
    case HowManyTimes = 1
}

protocol EditMedicineTimeDelegate : class {
    
    func didEditMedicineTime()
}

class EditOrAddMedicineVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var btnHowManyDays: UIButton!
    @IBOutlet var btnDays: [UIButton]!
    @IBOutlet weak var constraintTableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var txtMedicineName: UITextField!
    @IBOutlet weak var txtUnit: UITextField!
    @IBOutlet weak var txtInstructions: UITextField!
    @IBOutlet weak var txtStartDate: APJTextPickerView!
    
    @IBOutlet weak var txtEndDate: APJTextPickerView!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    private var settings : Settings!
    
    var medicine : Medicine?
    var medicineTimes : [MedicineTime] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        updateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    
    @IBAction func onClick_Save(_ sender: UIButton) {
        
        if txtMedicineName.text?.trim() == ""
        {
            view.makeToast("Please provide name of the medicine")
            return
        }
        
        let startDate = txtStartDate.text?.getDate()
        let endDate = txtEndDate.text?.getDate()
        
        if endDate! < startDate!
        {
            view.makeToast("End date must be greater or equal to start date")
            return
        }
        
        if medicine?.medicineName != txtMedicineName.text?.trim()
        {
            if let medicine = (RealmHelper.objects(type: Medicine.self)?.first(where: { (medicine) -> Bool in
                return medicine.medicineName == txtMedicineName.text?.trim()
            }))
            {
                self.showAlert(message: "Medicine with this name already exists. Do you want to replace?", leftButtonTitle: "Cancel", rightButtonTitle: "Proceed", completion: { (action) in
                    
                    if action == .eAlertActionOK
                    {
                        self.deleteMedicine(medicine)
                        self.saveMedicine()
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                })
                return
            }
        }
        if let medicine = medicine
        {
            deleteMedicine(medicine)
        }
        
        saveMedicine()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onClick_Day(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        
        lblDays.text = ""
        let selectedDays = btnDays.filter { (btnDay) -> Bool in
            return btnDay.isSelected
        }
        for (index, day) in selectedDays.enumerated()
        {
            lblDays.text?.append(day.accessibilityLabel!)
            if index < (selectedDays.count - 1)
            {
                lblDays.text?.append(", ")
            }
        }
    }
    
    @IBAction func onClick_HowManyTimes(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "",
                                      message: "Enter number of times medicine to be taken in a day.",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.tag = TextFieldTag.HowManyTimes.rawValue
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            let text = (textField.text == "") ? "1" : textField.text
            self.btnHowManyDays.setTitle(text, for: .normal)
            
            self.addSlots(no: Int(text!)!)
            self.tableView.reloadData()
            self.constraintTableHeight.constant = self.tableView.contentSize.height
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
        okAction.setValue(Constants.ThemeColorGreen, forKey: "titleTextColor")
        cancel.setValue(Constants.ThemeColorGreen, forKey: "titleTextColor")
        
        alert.addAction(okAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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

//MARK: - Private Methods
extension EditOrAddMedicineVC
{
    private func setUpUI()
    {
        self.title = "MEDICATIONS"
        let date = Date()
        txtStartDate.datePicker?.minimumDate = date
        txtEndDate.datePicker?.minimumDate = date
        txtStartDate.pickerDelegate = self
        txtEndDate.pickerDelegate = self
        txtStartDate.dateFormatter.dateStyle = .medium
        txtEndDate.dateFormatter.dateStyle = .medium
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(with: "MedicineDoseTimeCell")
        btnSave.roundView()
        txtStartDate.setLeftPadding(10)
        txtStartDate.applyShadow()
        txtEndDate.setLeftPadding(10)
        txtEndDate.applyShadow()
        
        settings = GenieDBHelper.getSettings()
        
        if medicine == nil
        {
            txtEndDate.text = date.getDateTimeString()
            txtStartDate.text = date.getDateTimeString()
            addSlots()
        }
        
        for button in btnDays
        {
            button.applyShadow()
        }
        
        btnHowManyDays.applyShadow()
        
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

    private func updateUI()
    {
        if let medicine = medicine
        {
            txtMedicineName.text = medicine.medicineName
            txtUnit.text = medicine.unit
            txtInstructions.text = medicine.instructions
            txtStartDate.text = medicine.startDate?.getDateTimeString()
            txtEndDate.text = medicine.endDate?.getDateTimeString()
            
            medicineTimes.removeAll()
            
            for medicine in medicine.medicineTimes
            {
                let newMedicineTime = MedicineTime()
                newMedicineTime.reminderIdentifiers = medicine.reminderIdentifiers
                newMedicineTime.noOfDozes = medicine.noOfDozes
                newMedicineTime.time = medicine.time
                
                medicineTimes.append(newMedicineTime)
            }
            
            btnHowManyDays.setTitle("\(medicineTimes.count)", for: .normal)
            tableView.reloadData()
            self.constraintTableHeight.constant = self.tableView.contentSize.height
            btnDays[0].isSelected = (medicine.days?.sunday)!
            btnDays[1].isSelected = (medicine.days?.monday)!
            btnDays[2].isSelected = (medicine.days?.tuesday)!
            btnDays[3].isSelected = (medicine.days?.wednesday)!
            btnDays[4].isSelected = (medicine.days?.thursday)!
            btnDays[5].isSelected = (medicine.days?.friday)!
            btnDays[6].isSelected = (medicine.days?.saturday)!
        }
    }
    
    private func addSlots(no:Int = 1)
    {
        medicineTimes.removeAll()
        
        if no > 0
        {
            for _ in 1...no
            {
                medicineTimes.append(MedicineTime())
            }
        }
        
    }
    
    private func saveMedicine()
    {
        medicine = Medicine()
        updateMedicineObject()
        RealmHelper.addObject(medicine!)
    }
    
    private func updateReminder(_ reminder:EKReminder, medicineTime:MedicineTime, forDate:Date)
    {
        let timeComponents = Calendar.current.dateComponents([.minute, .hour], from: medicineTime.time.getDate(format: "hh:mm a")!)
        var dateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: forDate)
        
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        reminder.calendar = Common.appDelegate.eventStore.defaultCalendarForNewReminders()
        reminder.title = "Take \(medicineTime.noOfDozes) dose\((medicineTime.noOfDozes > 1) ? "s" : "") of \(txtMedicineName.text!)"
        reminder.dueDateComponents = dateComponents
        
        if (settings.medicineReminder)
        {
            let reminderTime = Calendar.current.date(from: dateComponents)
            let alarm = EKAlarm(absoluteDate: reminderTime!)
            reminder.addAlarm(alarm)
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
    
    private func updateMedicineObject()
    {
        let medicineName = txtMedicineName.text?.trim()
        let unit = txtUnit.text?.trim()
        let instructions = txtInstructions.text?.trim()
        var startDate = txtStartDate.text?.getDate()
        let endDate = txtEndDate.text?.getDate()
        
        medicine?.medicineName = medicineName
        medicine?.unit = unit
        medicine?.instructions = instructions
        medicine?.startDate = startDate
        medicine?.endDate = endDate
        
        let week = Week()
        week.sunday = btnDays[0].isSelected
        week.monday = btnDays[1].isSelected
        week.tuesday = btnDays[2].isSelected
        week.wednesday = btnDays[3].isSelected
        week.thursday = btnDays[4].isSelected
        week.friday = btnDays[5].isSelected
        week.saturday = btnDays[6].isSelected
        
        medicine?.days = week
        
        while startDate! <= endDate! {
            
            let dayOfWeek = startDate?.dayOfWeek()
            
            if let btnDay = btnDays.first(where: { (button) -> Bool in
                return button.accessibilityLabel == dayOfWeek
            })
            {
                if btnDay.isSelected
                {
                    for medicineTime in medicineTimes
                    {
                        let reminder = EKReminder(eventStore: Common.appDelegate.eventStore)
                        medicineTime.reminderIdentifiers.append(reminder.calendarItemIdentifier)
                        updateReminder(reminder, medicineTime: medicineTime, forDate: startDate!)
                    }
                }
            }
            
            startDate = startDate?.addDays(1)
        }
        
        medicine?.medicineTimes.append(objectsIn: medicineTimes)
        
        
  
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
        
        for medicine in medicineTimes
        {
            medicine.reminderIdentifiers = List<String>()
        }
        
    }
}

// MARK:- UITableViewDataSource
extension EditOrAddMedicineVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return medicineTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicineDoseTimeCell") as! MedicineDoseTimeCell
        let medicineTime = medicineTimes[indexPath.row]
        cell.updateCellWithTime(time: medicineTime)
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension EditOrAddMedicineVC:  UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let medicine = medicineTimes[indexPath.row]
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditMedicineTimePopup") as! EditMedicineTimePopup
        destination.medicineTime = medicine
        destination.delegate = self
        destination.modalPresentationStyle = .overCurrentContext
        present(destination, animated: true, completion: nil)
    
    }
}

//MARK:- APJTextPickerViewDelegate
extension EditOrAddMedicineVC: APJTextPickerViewDelegate
{
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectDate date: Date) {
        print("Date Selected: \(date)")
        textPickerView.text = date.getDateTimeString()
        
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

// MARK: -  UITextFieldDelegate
extension EditOrAddMedicineVC : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == TextFieldTag.HowManyTimes.rawValue
        {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 2 // Bool
        }
        
        return true
    }
}

//MARK: - EditMedicineTimeDelegate
extension EditOrAddMedicineVC : EditMedicineTimeDelegate
{
    func didEditMedicineTime() {
        tableView.reloadData()
    }
    
    
}

//
//  EditOrAddTemperatureRecordVC.swift
//  GenieCanHelp
//
//  Created by Test Account on 4/30/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class EditOrAddTemperatureRecordVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnFarenheight: UIButton!
    @IBOutlet weak var btnCentigrade: UIButton!
    @IBOutlet weak var txtTemperature: UITextField!
    @IBOutlet weak var txtDateTime: APJTextPickerView!
    
    var record : BodyTemperature?
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        populateUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClick_TempUnit(_ sender: UIButton)
    {
        btnCentigrade.isSelected = false
        btnFarenheight.isSelected = false
        
        sender.isSelected = true
    }
    
    @IBAction func onClick_Save(_ sender: UIButton)
    {
        if txtTemperature.text?.trim() == ""
        {
            view.makeToast("Please enter temperature for data to be saved")
            return
        }
        
        if record == nil
        {
            record = BodyTemperature()
            updateObject()
            RealmHelper.addObject(record!, update: false)
        }
        else
        {
            RealmHelper.updateContext {
                self.updateObject()
            }
        }
        
        self.navigationController?.popViewController(animated: true)
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
extension EditOrAddTemperatureRecordVC
{
    private func setUpUI()
    {
        self.title = "Temperature Record".uppercased()
        txtDateTime.pickerDelegate = self
        txtDateTime.datePicker?.datePickerMode = .dateAndTime
        
        txtDateTime.setLeftPadding(10)
        txtDateTime.applyShadow()
        btnSave.roundView()
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
        if record != nil
        {
            txtDateTime.text = record?.time?.getDateTimeString(inFormat: "EEEE  dd-MM-yyyy hh:mm a")
            txtTemperature.text = record?.temperature
            btnCentigrade.isSelected = (record?.temperatureUnit == "C")
            btnFarenheight.isSelected = (record?.temperatureUnit == "F")
        }
        else
        {
            txtDateTime.text = Date().getDateTimeString(inFormat: "EEEE  dd-MM-yyyy hh:mm a")
            btnFarenheight.isSelected = false
            btnCentigrade.isSelected = true
        }
    }
    
    private func updateObject()
    {
        record?.time = txtDateTime.text?.getDate(format: "EEEE  dd-MM-yyyy hh:mm a")
        record?.temperature = txtTemperature.text
        record?.temperatureUnit = btnCentigrade.isSelected ? "C" : "F"
    }
}


//MARK:- APJTextPickerViewDelegate
extension EditOrAddTemperatureRecordVC: APJTextPickerViewDelegate
{
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectDate date: Date) {
        print("Date Selected: \(date)")
        textPickerView.text = date.getDateTimeString(inFormat: "EEEE  dd-MM-yyyy hh:mm a")
        
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

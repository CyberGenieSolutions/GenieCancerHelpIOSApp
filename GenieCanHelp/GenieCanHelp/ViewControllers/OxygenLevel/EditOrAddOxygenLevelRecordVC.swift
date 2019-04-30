//
//  EditOrAddOxygenLevelRecordVC.swift
//  GenieCanHelp
//
//  Created by Test Account on 4/30/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class EditOrAddOxygenLevelRecordVC: ParentVC {

    //MARK: - Properties
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtOxygenLevel: UITextField!
    @IBOutlet weak var txtDateTime: APJTextPickerView!
    
    var record : OxygenLevel?
    
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
    
    
    @IBAction func onClick_Save(_ sender: UIButton)
    {
        if txtOxygenLevel.text?.trim() == ""
        {
            view.makeToast("Please enter oxygen level for data to be saved")
            return
        }
        
        if record == nil
        {
            record = OxygenLevel()
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
extension EditOrAddOxygenLevelRecordVC
{
    private func setUpUI()
    {
        self.title = "Oxygen Level Record".uppercased()
        txtDateTime.pickerDelegate = self
        txtDateTime.datePicker?.datePickerMode = .dateAndTime
        txtOxygenLevel.delegate = self
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
            txtOxygenLevel.text = record?.level
        }
        else
        {
            txtDateTime.text = Date().getDateTimeString(inFormat: "EEEE  dd-MM-yyyy hh:mm a")
        }
    }
    
    private func updateObject()
    {
        record?.time = txtDateTime.text?.getDate(format: "EEEE  dd-MM-yyyy hh:mm a")
        record?.level = txtOxygenLevel.text
    }
}


//MARK:- APJTextPickerViewDelegate
extension EditOrAddOxygenLevelRecordVC: APJTextPickerViewDelegate
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

// MARK: - UITextFieldDelegate
extension EditOrAddOxygenLevelRecordVC : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtOxygenLevel
        {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 3 // Bool
        }
        
        return true
    }
}

//
//  EditProfileVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/3/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class EditProfileVC: ParentVC
{
    //MARK: - Properties
    
    @IBOutlet weak var txtPatientName: UITextField!
    @IBOutlet weak var txtDateOfBirth: APJTextPickerView!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtBMI: UITextField!
    @IBOutlet weak var txtSurfaceArea: UITextField!
    @IBOutlet weak var txtParentName: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtSuburb: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var profile : Profile?
    
    //MARK: - Life Cycle Methods
    
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
        
        if txtPatientName.text?.trim() == ""
        {
            view.makeToast("Patient's name cannot be empty")
            return
        }
        
        if txtEmail.text?.trim() != "" && !(txtEmail.text?.validateForEmail())!
        {
            view.makeToast("Please enter valid Email")
            return
        }
        
        saveProfile()
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
extension EditProfileVC
{
    
    private func setUpUI()
    {
        self.title = "PROFILE"
        txtDateOfBirth.datePicker?.maximumDate = Date().addYears(-10)
        txtDateOfBirth.pickerDelegate = self
        txtDateOfBirth.dateFormatter.dateStyle = .medium
        btnSave.roundView()
        txtDateOfBirth.setLeftPadding(10)
        txtDateOfBirth.applyShadow()
        
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
        txtPatientName.text = profile?.patientName
        txtDateOfBirth.text = profile?.dateOfBirth?.getDateTimeString() ?? txtDateOfBirth.datePicker?.maximumDate?.getDateTimeString()
        txtHeight.text = profile?.height
        txtWeight.text = profile?.weight
        txtSurfaceArea.text = profile?.surfaceArea
        txtBMI.text = profile?.bmi
        txtParentName.text = profile?.parentName
        txtPhoneNo.text = profile?.phoneNumber
        txtEmail.text = profile?.email
        txtStreet.text = profile?.state
        txtSuburb.text = profile?.suburb
        txtState.text = profile?.state
        txtPostCode.text = profile?.postalCode
    }
    
    private func saveProfile()
    {
        if profile == nil
        {
            profile = Profile()
            updateProfileObject()
            RealmHelper.addObject(profile!)
        }
        else
        {
            RealmHelper.updateContext {
                updateProfileObject()
            }
        }
    }
    
    private func updateProfileObject()
    {
        let patientName = txtPatientName.text?.trim()
        let dateOfBirth = txtDateOfBirth.text?.getDate()
        let height = txtHeight.text?.trim()
        let weight = txtWeight.text?.trim()
        let BMI = txtBMI.text?.trim()
        let surfaceArea = txtSurfaceArea.text?.trim()
        let parentName = txtParentName.text?.trim()
        let phoneNo = txtPhoneNo.text?.trim()
        let email = txtEmail.text?.trim()
        let street = txtStreet.text?.trim()
        let suburb = txtSuburb.text?.trim()
        let state = txtState.text?.trim()
        let postCode = txtPostCode.text?.trim()
        
        profile?.patientName = patientName
        profile?.dateOfBirth = dateOfBirth
        profile?.height = height
        profile?.weight = weight
        profile?.bmi = BMI
        profile?.surfaceArea = surfaceArea
        profile?.parentName = parentName
        profile?.phoneNumber = phoneNo
        profile?.email = email
        profile?.street = street
        profile?.suburb = suburb
        profile?.state = state
        profile?.postalCode = postCode
    }
}

//MARK:- APJTextPickerViewDelegate
extension EditProfileVC: APJTextPickerViewDelegate
{
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectDate date: Date) {
        print("Date Selected: \(date)")
        txtDateOfBirth.text = date.getDateTimeString()
        
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


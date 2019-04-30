//
//  EditMedicineTimePopup.swift
//  GenieCanHelp
//
//  Created by Test Account on 4/6/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class EditMedicineTimePopup: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var pickerTime: UIDatePicker!
    @IBOutlet weak var txtNoOfDoses: UITextField!
    weak var delegate : EditMedicineTimeDelegate?
    
    var medicineTime : MedicineTime!
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtNoOfDoses.delegate = self
        populateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    
    @IBAction func onClick_OK(_ sender: UIButton)
    {
        
        let noOfDoses = txtNoOfDoses.text?.trim()
        if  noOfDoses == ""
        {
            view.makeToast("Please enter no of doses")
            return
        }
        
        medicineTime.noOfDozes = Int(txtNoOfDoses.text!)!
        medicineTime.time = pickerTime.date.getDateTimeString(inFormat: "hh:mm a")
        
        view.endEditing(true)
        delegate?.didEditMedicineTime()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClick_Cancel(_ sender: UIButton)
    {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
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

// MARK: -  Private Methods
extension EditMedicineTimePopup
{
    private func populateUI()
    {
        txtNoOfDoses.text = "\(medicineTime.noOfDozes)"
        
        if let date = medicineTime.time.getDate(format: "hh:mm a")
        {
            pickerTime.date = date
        }
    }
}

// MARK: -  UITextFieldDelegate
extension EditMedicineTimePopup : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtNoOfDoses
        {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 2 // Bool
        }
        
        return true
    }
}

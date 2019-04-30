//
//  EditOrAddFuildIntakeVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 5/3/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class EditOrAddFuildIntakeVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnML: UIButton!
    @IBOutlet weak var btnCUP: UIButton!
    @IBOutlet weak var txtDateTime: APJTextPickerView!
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtAdd: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblUnit: UILabel!
    
    @IBOutlet weak var btnQuickAddCup: UIButton!
    @IBOutlet weak var btnQuickAddBottle: UIButton!
    @IBOutlet weak var btnQuickAddLargeBottle: UIButton!
    
    
    var record : FluidIntake?
    
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
    

    @IBAction func onClick_Add(_ sender: UIButton) {
        
        if txtAdd.text == ""
        {
            return
        }
        
        let newQuantity = Int(txtAdd.text!)
        
        var preQuantity = 0
        
        if txtQuantity.text != ""
        {
            preQuantity = Int(txtQuantity.text!)!
        }
        
        preQuantity = preQuantity + newQuantity!
        
        txtQuantity.text = "\(preQuantity)"
        
    }
    
    @IBAction func onClick_Cup(_ sender: UIButton)
    {
        
        var preQuantity = 0
        
        if txtQuantity.text != ""
        {
            preQuantity = Int(txtQuantity.text!)!
        }
        
        preQuantity = preQuantity + (btnML.isSelected ? 250 : 1)
        
        txtQuantity.text = "\(preQuantity)"
    }
    
    @IBAction func onClick_Bottle(_ sender: UIButton)
    {
        var preQuantity = 0
        
        if txtQuantity.text != ""
        {
            preQuantity = Int(txtQuantity.text!)!
        }
        
        preQuantity = preQuantity + (btnML.isSelected ? 500 : 2)
        
        txtQuantity.text = "\(preQuantity)"
    }
    
    @IBAction func onClick_LagreBottle(_ sender: UIButton) {
        
        var preQuantity = 0
        
        if txtQuantity.text != ""
        {
            preQuantity = Int(txtQuantity.text!)!
        }
        
        preQuantity = preQuantity + (btnML.isSelected ? 750 : 3)
        
        txtQuantity.text = "\(preQuantity)"
    }
    
    @IBAction func onClick_Unit(_ sender: UIButton)
    {
        btnML.isSelected = false
        btnCUP.isSelected = false
        
        sender.isSelected = true
        
        if btnML.isSelected
        {
            lblUnit.text = "ml"
        }else
        {
            lblUnit.text = "cup"
        }
    }
    
    @IBAction func onClick_Save(_ sender: UIButton)
    {
        
        if txtQuantity.text?.trim() == ""
        {
            view.makeToast("Please enter fluid intake for data to be saved")
            return
        }
        
        if record == nil
        {
            record = FluidIntake()
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
extension EditOrAddFuildIntakeVC
{
    private func setUpUI()
    {
        txtDateTime.isUserInteractionEnabled = false
        self.title = "FLUID INTAKE RECORD"
        txtDateTime.pickerDelegate = self
        txtDateTime.datePicker?.datePickerMode = .date
        
        txtDateTime.setLeftPadding(10)
        txtDateTime.applyShadow()
        btnSave.roundView()
        btnAdd.applyShadow()
        btnQuickAddCup.applyShadow()
        btnQuickAddBottle.applyShadow()
        btnQuickAddLargeBottle.applyShadow()
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
            txtDateTime.text = record?.time?.getDateTimeString(inFormat: "EEEE  dd-MM-yyyy")
            txtQuantity.text = "\((record?.quantity) ?? 0)"
            btnML.isSelected = (record?.unit == "ml")
            btnCUP.isSelected = (record?.unit == "cup")
            lblUnit.text = record?.unit
        }
        else
        {
            txtDateTime.text = Date().getDateTimeString(inFormat: "EEEE  dd-MM-yyyy")
            btnML.isSelected = true
            btnCUP.isSelected = false
        }
    }
    
    private func updateObject()
    {
        record?.time = txtDateTime.text?.getDate(format: "EEEE  dd-MM-yyyy")
        record?.quantity = Int(txtQuantity.text!)!
        record?.unit = btnCUP.isSelected ? "cup" : "ml"
    }
}


//MARK:- APJTextPickerViewDelegate
extension EditOrAddFuildIntakeVC: APJTextPickerViewDelegate
{
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectDate date: Date) {
        print("Date Selected: \(date)")
        textPickerView.text = date.getDateTimeString(inFormat: "EEEE  dd-MM-yyyy")
        
    }
}

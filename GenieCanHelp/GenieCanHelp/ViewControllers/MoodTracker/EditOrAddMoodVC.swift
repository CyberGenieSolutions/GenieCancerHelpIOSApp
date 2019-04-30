//
//  EditOrAddMoodVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/21/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class EditOrAddMoodVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet var btnMoods: [UIButton]!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtDetails: UITextField!
    @IBOutlet weak var txtTime: APJTextPickerView!
    var mood : Mood?
    
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
    
    
    //MARK: - Action Methods
    
    @IBAction func onClick_Mood(_ sender: UIButton)
    {
        for mood in btnMoods
        {
            mood.isSelected = false
            mood.backgroundColor = .clear
        }
        
        sender.isSelected = true
        sender.backgroundColor = Constants.ThemeColorGreen
    }
    
    @IBAction func onClick_Save(_ sender: UIButton)
    {
        guard let selectedMood = btnMoods.first(where: { (button) -> Bool in
            return button.isSelected == true
        })
        else
        {
            view.makeToast("Please select mood for data to be saved")
            return
        }
        
        if mood == nil
        {
            mood = Mood()
            updateMoodObject(selectedMood: selectedMood)
            RealmHelper.addObject(mood!, update: false)
        }
        else
        {
            RealmHelper.updateContext {
                self.updateMoodObject(selectedMood: selectedMood)
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
extension EditOrAddMoodVC
{
    private func setUpUI()
    {
        self.title = "MOOD TRACKER"
        txtTime.pickerDelegate = self
        txtTime.datePicker?.datePickerMode = .dateAndTime
        
        txtTime.setLeftPadding(10)
        txtTime.applyShadow()
        btnSave.roundView()
        
        for mood in btnMoods
        {
            mood.roundView()
        }
        
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
        if mood != nil
        {
            txtTime.text = mood?.time?.getDateTimeString(inFormat: "EEEE  dd-MM-yyyy hh:mm a")
            txtDetails.text = mood?.details
            
            if let selectedMood = btnMoods.first(where: { (button) -> Bool in
                return button.accessibilityLabel == mood?.mood
            })
            {
                onClick_Mood(selectedMood)
            }
            
        }
        else
        {
            txtTime.text = Date().getDateTimeString(inFormat: "EEEE  dd-MM-yyyy hh:mm a")
        }
    }
    
    private func updateMoodObject(selectedMood : UIButton)
    {
        mood?.time = txtTime.text?.getDate(format: "EEEE  dd-MM-yyyy hh:mm a")
        mood?.mood = selectedMood.accessibilityLabel
        mood?.details = txtDetails.text?.trim()
    }
}


//MARK:- APJTextPickerViewDelegate
extension EditOrAddMoodVC: APJTextPickerViewDelegate
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

//
//  EditOrAddContactsVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/4/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class EditOrAddContactsVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtSuburb: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    var contact: Contact?
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad()
    {
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
        
        if txtName.text?.trim() == ""
        {
            view.makeToast("Please provide name of the contact")
            return
        }
        
        if txtEmail.text?.trim() != "" && !(txtEmail.text?.validateForEmail())!
        {
            view.makeToast("Please enter valid Email")
            return
        }
        
        
        if contact?.contactName != txtName.text?.trim()
        {
            if let _ = (RealmHelper.objects(type: Contact.self)?.first(where: { (contact) -> Bool in
                return contact.contactName == txtName.text?.trim()
            }))
            {
                self.showAlert(message: "Contact with this name already exists. Do you want to replace?", leftButtonTitle: "Cancel", rightButtonTitle: "Proceed", completion: { (action) in
                    
                    if action == .eAlertActionOK
                    {
                        self.saveContact()
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                })
                return
            }
        }
        if let contact = contact
        {
            RealmHelper.deleteObject(contact)
        }
        saveContact()
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
extension EditOrAddContactsVC
{

    private  func setUpUI()
    {
        self.title = "CONTACTS"
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
        btnSave.roundView()
        txtName.text = contact?.contactName
        txtPhoneNo.text = contact?.phoneNumber
        txtEmail.text = contact?.email
        txtStreet.text = contact?.state
        txtSuburb.text = contact?.suburb
        txtState.text = contact?.state
        txtPostCode.text = contact?.postalCode
    }
    
    private func saveContact()
    {
        contact = Contact()
        updateContactObject()
        RealmHelper.addObject(contact!)
    }
    
    private func updateContactObject()
    {
        let contactName = txtName.text?.trim()
        let phoneNo = txtPhoneNo.text?.trim()
        let email = txtEmail.text?.trim()
        let street = txtStreet.text?.trim()
        let suburb = txtSuburb.text?.trim()
        let state = txtState.text?.trim()
        let postCode = txtPostCode.text?.trim()
        
        contact?.contactName = contactName
        contact?.phoneNumber = phoneNo
        contact?.email = email
        contact?.street = street
        contact?.suburb = suburb
        contact?.state = state
        contact?.postalCode = postCode
    }
}

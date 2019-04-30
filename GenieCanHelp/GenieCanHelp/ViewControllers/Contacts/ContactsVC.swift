//
//  ContactsVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/4/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class ContactsVC: ParentVC
{

    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var btnAddContact: UIButton!
    
    private var contacts : [Contact] = []
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getContacts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Action Methods
    
    @IBAction func onClick_AddContact(_ sender: UIButton)
    {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddContactsVC") as! EditOrAddContactsVC
        self.navigationController?.pushViewController(destination, animated: true)
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

// MARK:- Private Methods
extension ContactsVC
{
    private func setUpUI()
    {
        self.title = "CONTACTS"
        tableView.registerNib(with: "ContactCell")
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        btnAddContact.roundView()
        addRightBarButtons()
    }
    
    private func addRightBarButtons()
    {
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.setTitle("Add", for: .normal)
        saveButton.titleLabel?.font = Constants.BarItemFont
        saveButton.addTarget(self, action: #selector(onClick_AddContact(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func getContacts()
    {
        if let tempContacts = RealmHelper.objects(type: Contact.self)
        {
            contacts = Array(tempContacts)
            tableView.reloadData()
        }
    }
}

// MARK:- UITableViewDataSource
extension ContactsVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        let contact = contacts[indexPath.row]
        cell.updateCellWithContact(contact)
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension ContactsVC:  UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let contact = contacts[indexPath.row]
        
        var options : [ActionSheetOption] = [.eActionSheetOptionEdit, .eActionSheetOptionDelete]
        
        if let phone = contact.phoneNumber, phone != ""
        {
            options.append(.eActionSheetOptionCall)
        }
        
        if let email = contact.email, email != ""
        {
            options.append(.eActionSheetOptionEmail)
        }
        
        self.showActionSheet(title: contact.contactName, otherOptions: options) { (option) in
            
            switch(option)
            {
            case .eActionSheetOptionEdit:
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddContactsVC") as! EditOrAddContactsVC
                destination.contact = contact
                self.navigationController?.pushViewController(destination, animated: true)
                
                break
                
            case .eActionSheetOptionDelete:
                
                self.contacts.remove(at: indexPath.row)
                RealmHelper.deleteObject(contact)
                tableView.reloadData()
                break
                
            case .eActionSheetOptionCall:
                self.call(number: contact.phoneNumber!)
                break
                
            case .eActionSheetOptionEmail:
                self.sendEmail(contact.email!)
                break
                
            default:
                break
            }
        }
    }
}

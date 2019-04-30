//
//  EditListVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/20/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class EditListVC: ParentVC {

    @IBOutlet weak var tableView: UITableView!
    {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var txtAddNewItem: UITextField!
    @IBOutlet weak var txtListTitle: UITextField!
    
    var list : MyList?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClick_AddNewItem(_ sender: UIButton)
    {
        if txtAddNewItem.text?.trim() != ""
        {
            RealmHelper.updateContext {
                self.list?.items.append(txtAddNewItem.text?.trim() ?? "")
                self.tableView.reloadData()
                txtAddNewItem.text = ""
            }
        }
    }
    
    override func onClick_back() {
        super.onClick_back()
        
        RealmHelper.updateContext {
            self.list?.title = txtListTitle.text?.trim()
        }
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
extension EditListVC
{
    private func setUpUI()
    {
        tableView.registerNib(with: "ListItemCell")
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
    }
    
    private func updateUI()
    {
        self.title = self.list?.title
        txtListTitle.text = self.list?.title
    }
    
    private func showEditItemDialogFor(index: Int)
    {
        
        let item = list?.items[index]
        
        let alert = UIAlertController(title: "",
                                      message: "Edit list item title",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            
            textField.text = item
            //textField.delegate = self
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            let text = textField.text
            
            if text?.trim() != ""
            {
                RealmHelper.updateContext {
                    self.list?.items[index] = (text?.trim()) ?? ""
                    self.tableView.reloadData()
                }
            }
            
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) -> Void in })
        okAction.setValue(Constants.ThemeColorGreen, forKey: "titleTextColor")
        cancel.setValue(Constants.ThemeColorGreen, forKey: "titleTextColor")
        
        alert.addAction(okAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}


// MARK:- UITableViewDataSource
extension EditListVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return list?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell") as! ListItemCell
        let item = list?.items[indexPath.row]
        cell.lblItemName.text = item
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension EditListVC:  UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        self.showActionSheet(title: "", otherOptions: [.eActionSheetOptionEdit, .eActionSheetOptionDelete]) { (option) in
            
            switch(option)
            {
            case .eActionSheetOptionEdit:
                
                self.showEditItemDialogFor(index: indexPath.row)
                
                break
                
            case .eActionSheetOptionDelete:
                
                RealmHelper.updateContext {
                    self.list?.items.remove(at: indexPath.row)
                    tableView.reloadData()
                }
                
                break
                
            default:
                break
            }
        }
    }
}

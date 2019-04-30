//
//  MyListsVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/19/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class MyListsVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
        {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var btnAddList: UIButton!
    
    private var myLists : [MyList] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getLists()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action Methods
    
    @IBAction func onClick_AddList(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "",
                                      message: "Enter list title",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            
            //textField.delegate = self
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            let text = textField.text
            
            if text?.trim() != ""
            {
                let list = MyList()
                list.title = text?.trim()
                RealmHelper.addObject(list, update:false)
                self.getLists()
            }
            
            
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


// MARK:- Private Methods
extension MyListsVC
{
    private func setUpUI()
    {
        self.title = "MY LISTS"
        tableView.registerNib(with: "MyListCell")
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        btnAddList.roundView()
        
        addRightBarButtons()
    }
    
    private func addRightBarButtons()
    {
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.setTitle("Add", for: .normal)
        saveButton.titleLabel?.font = Constants.BarItemFont
        saveButton.addTarget(self, action: #selector(onClick_AddList(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func getLists()
    {
        if let options = RealmHelper.objects(type: MyList.self), (options.count > 0)
        {
            myLists = Array(options)
            tableView.reloadData()
        }
        else
        {
            if let path = Bundle.main.path(forResource: "DefaultLists", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Array<Dictionary<String,Any>> {
                        // do stuff
                        for option in jsonResult
                        {
                            let item = MyList.fromDictionary(dictionary:option)
                            myLists.append(item)
                        }
                        
                        RealmHelper.addObjects(myLists, update:false)
                    }
                } catch {
                    // handle error
                }
            }
        }
    }
}

// MARK:- UITableViewDataSource
extension MyListsVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return myLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyListCell") as! MyListCell
        let list = myLists[indexPath.row]
        cell.updateCellWithList(list)
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension MyListsVC:  UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let list = myLists[indexPath.row]
        
        self.showActionSheet(title: "", otherOptions: [.eActionSheetOptionEdit, .eActionSheetOptionDelete]) { (option) in
            
            switch(option)
            {
            case .eActionSheetOptionEdit:
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditListVC") as! EditListVC
                destination.list = list
                self.navigationController?.pushViewController(destination, animated: true)
                
                break
                
            case .eActionSheetOptionDelete:
                
                self.myLists.remove(at: indexPath.row)
                RealmHelper.deleteObject(list)
                tableView.reloadData()
                break
                
            default:
                break
            }
        }
    }
}

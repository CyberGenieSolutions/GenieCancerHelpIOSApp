//
//  NotesToKeepVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/18/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class NotesToKeepVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
        {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var btnAddMedicine: UIButton!
    
    private var notes : [Note] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNotes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    
    @IBAction func onClick_AddNote(_ sender: UIButton)
    {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddNotesToKeepVC") as! EditOrAddNotesToKeepVC
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
extension NotesToKeepVC
{
    private func setUpUI()
    {
        self.title = "NOTES TO KEEP"
        tableView.registerNib(with: "NotesToKeepCell")
        tableView.estimatedRowHeight = 30
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        btnAddMedicine.roundView()
        
        addRightBarButtons()
    }
    
    private func addRightBarButtons()
    {
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        saveButton.setTitle("Add", for: .normal)
        saveButton.titleLabel?.font = Constants.BarItemFont
        saveButton.addTarget(self, action: #selector(onClick_AddNote(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func getNotes()
    {
        if let tempNotes = RealmHelper.objects(type: Note.self)
        {
            notes = Array(tempNotes)
            tableView.reloadData()
        }
    }
}

// MARK:- UITableViewDataSource
extension NotesToKeepVC:  UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesToKeepCell") as! NotesToKeepCell
        let note = notes[indexPath.row]
        cell.updateCellWithNote(note)
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension NotesToKeepVC:  UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let note = notes[indexPath.row]
        
        self.showActionSheet(title: "", otherOptions: [.eActionSheetOptionEdit, .eActionSheetOptionDelete]) { (option) in
            
            switch(option)
            {
            case .eActionSheetOptionEdit:
                
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditOrAddNotesToKeepVC") as! EditOrAddNotesToKeepVC
                destination.note = note
                self.navigationController?.pushViewController(destination, animated: true)
                
                break
                
            case .eActionSheetOptionDelete:
                
                self.notes.remove(at: indexPath.row)
                RealmHelper.deleteObject(note)
                tableView.reloadData()
                break
                
            default:
                break
            }
        }
    }
}

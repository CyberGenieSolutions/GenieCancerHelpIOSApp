//
//  EditOrAddNotesToKeepVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/18/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class EditOrAddNotesToKeepVC: ParentVC {

    var note : Note?
    
    @IBOutlet weak var txtViewDetails: DALinedTextView!
    @IBOutlet weak var txtTitle: UITextField!
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        populateUI()
        addRightBarButtons()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action Methods
    
    @objc func onClick_Save()
    {
        if txtTitle.text?.trim() == "" && txtViewDetails.text.trim() == ""
        {
            //view.makeToast("Please enter some notes")
            return
        }
        
        if note == nil
        {
            note = Note()
            updateNoteOpject()
            RealmHelper.addObject(note!, update:false)
        }
        else
        {
            RealmHelper.updateContext {
                updateNoteOpject()
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onClick_Delete()
    {
        if let note = self.note
        {
            RealmHelper.deleteObject(note)
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


// MARK:- Private Methods
extension EditOrAddNotesToKeepVC
{
    private func setUpUI()
    {
        self.title = "NOTES TO KEEP"
        txtViewDetails.text = ""
        txtViewDetails.backgroundColor = .clear
        txtViewDetails.alwaysBounceVertical = true;
        txtViewDetails.textContainerInset = UIEdgeInsetsMake(18.0, 10.0, 8.0, 10.0)
        txtViewDetails.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        txtViewDetails.verticalLineColor = UIColor.red
        txtViewDetails.horizontalLineColor = UIColor.blue
    }
    
    private func populateUI()
    {
        if let note = note
        {
            txtTitle.text = note.title
            txtViewDetails.text = note.details
        }
    }
    
    private func addRightBarButtons()
    {
        //let deleteImage = #imageLiteral(resourceName: "delete")
        let deleteButton = UIButton(type: .custom)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.titleLabel?.font = Constants.BarItemFont
        deleteButton.addTarget(self, action: #selector(onClick_Delete), for: .touchUpInside)
        let deleteBarButton = UIBarButtonItem(customView: deleteButton)
        
        //let saveImage = #imageLiteral(resourceName: "save")
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //saveButton.setImage(saveImage, for: .normal)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = Constants.BarItemFont
        saveButton.addTarget(self, action: #selector(onClick_Save), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        //let deleteBarButton: UIBarButtonItem = UIBarButtonItem(image: deleteImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClick_Delete))
        
        navigationItem.rightBarButtonItems = [saveBarButton ,deleteBarButton]
    }
    
    private func updateNoteOpject()
    {
        note?.title = txtTitle.text
        note?.details = txtViewDetails.text
        
        if txtTitle.text?.trim() == ""
        {
            var tempText = txtViewDetails.text
            tempText = tempText?.replacingOccurrences(of: "\n", with: " ")
            
            let words = tempText?.components(separatedBy: " ")
            
            let numOfWords = ((((words?.count) ?? 0) >= 3) ? 3 : words?.count) ?? 0
            
            var title = ""
            for i in 0..<numOfWords
            {
                title = title + words![i] + " "
            }
            
            note?.title = title.trim()
        }
    }
}

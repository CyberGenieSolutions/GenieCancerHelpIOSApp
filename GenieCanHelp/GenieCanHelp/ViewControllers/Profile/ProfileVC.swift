//
//  ProfileVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/3/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class ProfileVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var lblPatientName: UILabel!
    @IBOutlet weak var lblDateOfBirth: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblSurfaceArea: UILabel!
    @IBOutlet weak var lblBMI: UILabel!
    @IBOutlet weak var lblParentName: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    private var profile : Profile?
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PROFILE"
        addRightBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Methods
    
    @objc func onClick_Edit()
    {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        destination.profile = profile
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @objc func onClick_Delete()
    {
        RealmHelper.deleteObjectsOf(type: Profile.self)
        reset()
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
extension ProfileVC
{
    private func addRightBarButtons()
    {
        //let editImage = #imageLiteral(resourceName: "edit")
        let editButton = UIButton(type: .custom)
        editButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //editButton.setImage(editImage, for: .normal)
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.font =  Constants.BarItemFont
        editButton.addTarget(self, action: #selector(onClick_Edit), for: .touchUpInside)
        let editBarButton = UIBarButtonItem(customView: editButton)
    
        //let deleteImage = #imageLiteral(resourceName: "delete")
        let deleteButton = UIButton(type: .custom)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        deleteButton.titleLabel?.font = Constants.BarItemFont
        //deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(onClick_Delete), for: .touchUpInside)
        let deleteBarButton = UIBarButtonItem(customView: deleteButton)
        //let deleteBarButton: UIBarButtonItem = UIBarButtonItem(image: deleteImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClick_Delete))
        
        navigationItem.rightBarButtonItems = [deleteBarButton ,editBarButton]
    }
    
    private func getProfile()
    {
        if let tempProfile = RealmHelper.objects(type: Profile.self), (tempProfile.count > 0)
        {
            profile = Array(tempProfile).first!
            populateUI()
        }
        else
        {
           reset()
        }
        
    }
    
    private func reset()
    {
        lblPatientName.text = ""
        lblDateOfBirth.text = ""
        lblHeight.text = ""
        lblWeight.text = ""
        lblSurfaceArea.text = ""
        lblBMI.text = ""
        lblParentName.text = ""
        lblPhoneNo.text = ""
        lblEmail.text = ""
        lblAddress.text = ""
        profile = nil
    }
    
    private func populateUI()
    {
        lblPatientName.text = profile?.patientName
        lblDateOfBirth.text = profile?.dateOfBirth?.getDateTimeString()
        lblHeight.text = profile?.height
        lblWeight.text = profile?.weight
        lblSurfaceArea.text = profile?.surfaceArea
        lblBMI.text = profile?.bmi
        lblParentName.text = profile?.parentName
        lblPhoneNo.text = profile?.phoneNumber
        lblEmail.text = profile?.email
        
        var address = (profile?.street) ?? ""
        
        if let suburb = profile?.suburb
        {
            address += " " + suburb
        }
        
        if let state = profile?.state
        {
            address += " " + state
        }
        
        if let postalCode = profile?.postalCode
        {
            address += " " + postalCode
        }
        
        lblAddress.text = address
    }
}



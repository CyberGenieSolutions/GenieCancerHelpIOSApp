//
//  MainMenuVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 4/1/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController
{

    //MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource : [MainMenuOption] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOptions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsHelper.trackScreen(self.title ?? "", className: classForCoder.description())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Action Methods
    
    @objc func onClick_Settings()
    {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
}

//MARK: - Private Methods
extension MainMenuVC
{
    
    private func setUpUI()
    {
        self.title = "GenieCanHelp"
        addRightBarButton()
    }
    
    
    private func addRightBarButton()
    {
        let settingImage = UIImage(named: "settings_white")
        let settingButton = UIButton(type: .custom)
        settingButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        settingButton.setImage(settingImage, for: .normal)
        settingButton.addTarget(self, action: #selector(onClick_Settings), for: .touchUpInside)
        let settingBarButton = UIBarButtonItem(customView: settingButton)
        
        navigationItem.rightBarButtonItems = [settingBarButton]
    }
    
    private func getOptions()
    {
        let build = UserDefaults.standard.string(forKey: Constants.BuildVersion)
        let newBuild = Common.buildVersion()
        if build != newBuild
        {
            if let path = Bundle.main.path(forResource: "MainMenuJson", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Array<Dictionary<String,Any>> {
                        // do stuff
                        for option in jsonResult
                        {
                            let item = MainMenuOption.fromDictionary(dictionary:option)
                            dataSource.append(item)
                        }
                        RealmHelper.deleteObjectsOf(type: MainMenuOption.self)
                        RealmHelper.addObjects(dataSource)
                        
                        dataSource = dataSource.filter { (option) -> Bool in
                            return option.isVisible
                        }
                        
                        UserDefaults.standard.set(newBuild, forKey: Constants.BuildVersion)
                    }
                } catch {
                    // handle error
                }
            }
        }
        else
        {
            if let options = RealmHelper.objects(type: MainMenuOption.self)?.filter({ (option) -> Bool in
                return option.isVisible
            })
            {
                dataSource = Array(options)
                collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainMenuVC : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let item = dataSource[indexPath.row]
        
        switch item.optionName! {
            
        case OptionName.PROFILE.rawValue:
            self.performSegue(withIdentifier: "ProfileVC", sender: self)
            break
            
        case OptionName.CONTACTS.rawValue:
            self.performSegue(withIdentifier: "ContactsVC", sender: self)
            break
            
        case OptionName.MEDICATIONS.rawValue:
            self.performSegue(withIdentifier: "MedicationsVC", sender: self)
            break
            
        case OptionName.APPOINTMENTS.rawValue:
            self.performSegue(withIdentifier: "AppointmentsVC", sender: self)
            break
            
        case OptionName.NOTES_TO_KEEP.rawValue:
            self.performSegue(withIdentifier: "NotesToKeepVC", sender: self)
            break
            
        case OptionName.MOOD_TRACKER.rawValue:
            self.performSegue(withIdentifier: "MoodTrackerVC", sender: self)
            break
            
        case OptionName.BODY_TEMPERATURE.rawValue:
            self.performSegue(withIdentifier: "TemperatureRecordsVC", sender: self)
            break
            
        case OptionName.OXYGEN_LEVEL.rawValue:
            self.performSegue(withIdentifier: "OxygenLevelRecordsVC", sender: self)
            break
            
        case OptionName.USEFUL_LINKS.rawValue:
            self.performSegue(withIdentifier: "UsefulLinksVC", sender: self)
            break
            
        case OptionName.MY_LISTS.rawValue:
            self.performSegue(withIdentifier: "MyListsVC", sender: self)
            break
            
        case OptionName.FLUID_INTAKE.rawValue:
            self.performSegue(withIdentifier: "FluidIntakeVC", sender: self)
            break
            
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainMenuVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (UIScreen.main.bounds.width - 30 )/2
        let height = UIScreen.main.bounds.width * (125.0/414.0)
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDataSource
extension MainMenuVC : UICollectionViewDataSource
{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainMenuCell", for: indexPath) as! MainMenuCell
        
        let item = dataSource[indexPath.row]
        cell.updateCellWithItem(item: item)
        
        return cell
    }
}

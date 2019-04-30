//
//  MainMenuSettingsVC.swift
//  GenieCanHelp
//
//  Created by Shehzad on 5/4/18.
//  Copyright © 2018 Shehzad. All rights reserved.
//

import UIKit

class MainMenuSettingsVC: ParentVC {

    //MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    {
        didSet{
            collectionView.dataSource = self
        }
    }
    private var dataSource : [MainMenuOption] = []
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension MainMenuSettingsVC
{
    private func setUp()
    {
        self.title = "Main Menu Settings".uppercased()
        collectionView.register(UINib(nibName: "MainMenuSettingCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MainMenuSettingCell")
        
        if let options = RealmHelper.objects(type: MainMenuOption.self), (options.count > 0)
        {
            dataSource = Array(options)
            dataSource.remove(at: 0)
        }
    }
}


// MARK : - UICollectionViewDelegateFlowLayout
//extension MainMenuSettingsVC : UICollectionViewDelegateFlowLayout
//{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        let width = (UIScreen.main.bounds.width - 20.0 )
//        let height : CGFloat = 40.0
//        return CGSize(width: width, height: height)
//    }
//}

// MARK: - UICollectionViewDataSource
extension MainMenuSettingsVC : UICollectionViewDataSource
{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainMenuSettingCell", for: indexPath) as! MainMenuSettingCell
        
        let item = dataSource[indexPath.row]
        cell.updateCellWithOption(item)
        
        return cell
    }
}

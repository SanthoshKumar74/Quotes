//
//  CollectionViewController.swift
//  Quotes
//
//  Created by Santhosh on 15/03/22.
//

import UIKit
import GoogleSignIn

class CollectionViewController:UICollectionViewController
{
    
    private var sectionInsets = UIEdgeInsets(top: 5, left: 10 ,bottom: 5, right: 10)
    private var itemsPerRow:CGFloat = 3
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance.signOut()
        navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
       navigationItem.hidesBackButton = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Category.testData.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        cell.configure(category: Category.testData[indexPath.row],image:UIImage(systemName: "circle")!)
        if indexPath == IndexPath(row: 0, section: 0) {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addGoal", for: indexPath)
            return addCell
        }
        return cell
    }
    
  
}


extension CollectionViewController:UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingspace = sectionInsets.left * (itemsPerRow + 1)
        let availableWIdth = view.frame.width - paddingspace
        let width = availableWIdth / itemsPerRow

        return CGSize(width: width, height: width)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    
}

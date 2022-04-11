//
//  CollectionViewController.swift
//  Quotes
//
//  Created by Santhosh on 15/03/22.
//

import UIKit
import GoogleSignIn
import CoreData


class CategoryViewController:UICollectionViewController
{
    let notion = NotionAPI()
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var textField = UITextField()
    private var categories:[Category] = []
    private var quotes:[Quotes] = []
    private var sectionInsets = UIEdgeInsets(top: 20, left: 15 ,bottom: 20, right: 15)
    private var itemsPerRow:CGFloat = 3
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        GIDSignIn.sharedInstance.signOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    let refreshControl = UIRefreshControl()
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
       navigationItem.hidesBackButton = true
        //self.categories = notion.retriveData()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        //retriveData()
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        notion.retriveData(){ result in
//            switch result{
//            case .Success(_,let categories,_):
//
//
//                self.categories = categories
//               DispatchQueue.main.async {
//                   print("succeded")
//                   for category in categories {
//                       print(category.name!)
//                   }
//                    self.collectionView.reloadData()
//               }
//
//            case .Failure(let error):
//                print(error)
//            }
            
            self.retriveData()
    }
        
}
}


//MARK: CollectionViewDelegate
extension CategoryViewController{
   
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let firstIndex = IndexPath(row: 0, section: 0)
        if indexPath == firstIndex
        {
            let alert = UIAlertController(title: "Add a Category", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add a Category", style: .default) { action in
                let category = Category(context: self.context)
                category.name = self.textField.text!
                self.categories.append(category)
                try! self.context.save()
                self.retriveData()
                self.collectionView.reloadData()
            
            }
            alert.addAction(action)
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Create a New Category"
                self.textField = alertTextField
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else{
            performSegue(withIdentifier: "goToQuotes", sender: self)
        }
    }
}
//MARK: CollectionViewDataSource
extension CategoryViewController
{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(categories.count)
        return categories.count + 1
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if indexPath == IndexPath(row: 0, section: 0) {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addGoal", for: indexPath)
            return addCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        print(categories[indexPath.row-1].name)
        cell.configure(category: categories[indexPath.row-1],image:UIImage(named:"Quotes")!)
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuotesViewController
        let indexPath = collectionView.indexPathsForSelectedItems
        destinationVC.selectedCategory = categories[indexPath![0].row-1]
        
    }
  
}

// MARK: CollectionViewFlowLayoutDelegate

extension CategoryViewController:UICollectionViewDelegateFlowLayout
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

//MARK: CoreData Methods
extension CategoryViewController
{
    
    func retriveData()
    {
        
        do{
    try  categories = context.fetch(Category.fetchRequest()) as [Category]
}
        catch
        {
    print("error Loading Data\(error)")
}
        //print(categories.count)
        collectionView.reloadData()
    }
    
}

//MARK: Refresh Control
extension CategoryViewController
{
    @objc func refresh()
    {
    
        self.notion.retriveData(){ result in
//            switch result{
//            case .Success(_,let categories,_):
//                self.categories = categories
//                print(categories.count)
//               DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//
//
//            case .Failure(let error):
//                print(error)
            self.retriveData()
            }
            
        
    
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()

                
    }
}


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
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        var text = UITextField()
                let alert = UIAlertController(title: "Delete Category", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Delete all Quotes Associated with the author", style: .default, handler: { _ in
                    alert.addTextField { alertTextField in
                        alertTextField.placeholder = "Create a New Category"
                        text = alertTextField
                    }
                    self.notion.deleteCategory(category:text.text! )
                    self.navigationController?.popViewController(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
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
        collectionView.allowsMultipleSelection =  true
        collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
       // notion.retriveData(){ result in
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
    //}
        
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
              print("Count after dta retrived from coredata")
              print(self.categories.count)
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
            self.categories = categories.unique(){$0.name}
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

extension CategoryViewController{
  
  override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    let content = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) {  _ in
      let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil) { [self] _ in
        let action = UIAlertController(title: "Confirm Delete all Quotes in \(self.categories[indexPath.row-1].name!)", message: "Deletes all the quotes associated with this category", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
          print("confirm")
          self.notion.deleteCategory(category: self.categories[indexPath.row-1].name!)
          self.categories.remove(at: indexPath.row-1)
          self.collectionView.reloadData()
          
        }
        action.addAction(confirm)
        action.addAction(cancel)
        self.present(action, animated: true)
      }
      return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])

    }
    return content
  }
    
    
}
    



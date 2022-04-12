//
//  NewQuoteViewController.swift
//  Quotes
//
//  Created by Santhosh on 18/03/22.
//

import UIKit
import CoreData

class QuotesViewController:UITableViewController
{
    
     var selectedCategory : Category?
    let notion = NotionAPI()
    let quotesRefreshControl = UIRefreshControl()
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var quotesToShow:[Quotes] = []


    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        quotesRefreshControl.tintColor = .blue
        quotesRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(quotesRefreshControl)
        //self.retriveData(category: selectedCategory!)
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
            
        
       // self.notion.retriveData(){ [self] Result in
           // switch Result{

           // case .Success( _, _, _):
                retriveData(category: selectedCategory!)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                print(self.quotesToShow)
          //  case .Failure(let error):
               // print(error)
           // }
           // self.retriveData(category: selectedCategory!)
        }
    
    
    
    
  
    //private var selectedCategory:Category
    func retriveData(category:Category)
    {
     
        
            do{
                let fetchrecquest = NSFetchRequest<NSFetchRequestResult>(entityName: "Quotes")
               let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", category.name!)
                fetchrecquest.predicate = predicate
                try quotesToShow = context.fetch(fetchrecquest) as! [Quotes]
                self.quotesToShow = quotesToShow.unique(){$0.quote}
                print("Count inside retriveData")
                print(quotesToShow.count)
                
            }catch{
                print("error Loading Data\(error)")
            }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
         let destinationVC = segue.destination as! NewQuoteViewController
         if segue.identifier == "editQuote"{
           
             destinationVC.configure(quote:quotesToShow[tableView.indexPathForSelectedRow!.row])
             destinationVC.selectedCategory = selectedCategory!
         }

         destinationVC.selectedCategory = selectedCategory!
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return UITableView.automaticDimension
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.quotesToShow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell") as! QuoteCell
        
        cell.configure(quote:quotesToShow[indexPath.row])
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editQuote", sender: self)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       return .delete
   }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        notion.deleteQuote(quote:quotesToShow[indexPath.row].quote!)
        context.delete(quotesToShow[indexPath.row])
        quotesToShow.remove(at: indexPath.row)
        try! context.save()
        print("Count after deleting from coredata")
        print(quotesToShow.count)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.performBatchUpdates({

            retriveData(category: selectedCategory!)
            print("Count after retriving from coredata")
            print(quotesToShow)
            
        }) { (_) in
            tableView.reloadData()
        }


   }

}


extension QuotesViewController
{
    @objc func refresh()
    {
        
    
        
        self.notion.retriveData(){ [self] Result in
            switch Result{

            case .Success( _, _, _):
                self.retriveData(category: selectedCategory!)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                print(self.quotesToShow)
            case .Failure(let error):
                print(error)
            }
               // self.retriveData(category: selectedCategory!)
        
        }
        
    
     
        tableView.reloadData()
        quotesRefreshControl.endRefreshing()
        
    }
}







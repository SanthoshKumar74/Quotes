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
    
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        self.retriveData(category: selectedCategory!)
        tableView.reloadData()
    }
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var Quotes:[Quotes] = []
    //private var selectedCategory:Category
    func retriveData(category:Category)
    {
        
            do{
                let fetchrecquest = NSFetchRequest<NSManagedObject>(entityName: "Quotes")
                let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", category.name!)
                fetchrecquest.predicate = predicate
                try Quotes = context.fetch(fetchrecquest) as! [Quotes]
               print(Quotes.count)
            }catch{
                print("error Loading Data\(error)")
            }
        tableView.reloadData()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
         if segue.identifier == "editQuote"{
             let destinationVC = segue.destination as! NewQuoteViewController
             destinationVC.configure(quote:Quotes[tableView.indexPathForSelectedRow!.row])
         }
         let destinationVC = segue.destination as! NewQuoteViewController
         destinationVC.selectedCategory = selectedCategory!
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return UITableView.automaticDimension
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.Quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell") as! QuoteCell
        
        cell.configure(quote:Quotes[indexPath.row])
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editQuote", sender: self)
    }
    
}







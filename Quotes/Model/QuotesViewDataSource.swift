//
//  QuotesViewDataSource.swift
//  Quotes
//
//  Created by Santhosh on 18/03/22.
//

import UIKit
import CoreData

class QuotesViewDataSource:NSObject
{
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
            }catch{
                print("error Loading Data\(error)")
            }
        
    }
}

//MARK: TableViewDataSource
extension QuotesViewDataSource:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.Quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell") as! QuoteCell
        
        cell.configure(quote:Quotes[indexPath.row])
        
        return cell
    }
}


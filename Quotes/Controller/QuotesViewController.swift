//
//  NewQuoteViewController.swift
//  Quotes
//
//  Created by Santhosh on 18/03/22.
//

import UIKit

class QuotesViewController:UITableViewController
{
    private let datasource = QuotesViewDataSource()
    
     var selectedCategory : Category?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = datasource
        datasource.retriveData(category: selectedCategory!)
    }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! NewQuoteViewController
        destinationVC.selectedCategory = selectedCategory!
    }
    

}



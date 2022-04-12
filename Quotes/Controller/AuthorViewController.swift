//
//  AuthorViewController.swift
//  Quotes
//
//  Created by Santhosh on 29/03/22.
//

import UIKit

class AuthorViewController:UITableViewController{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var authors:[Author] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        retriveData()
    }
    
}

//MARK: AuthorDataSource

extension AuthorViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "authorCell")
        cell?.textLabel?.text = authors[indexPath.row].name
        return cell!
    }
}

//MARK: TableViewDelegat

extension AuthorViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        dismiss(animated: true, completion: nil)
        
        }
}

extension AuthorViewController
{
    func retriveData()
    {
        do{
            try authors = context.fetch(Author.fetchRequest()) as [Author]
            authors = authors.unique(){$0.name}
        }
        catch{
            print("Error fetching Data\(error)")
        }
    }
}



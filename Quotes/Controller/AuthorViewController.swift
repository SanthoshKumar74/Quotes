//
//  AuthorViewController.swift
//  Quotes
//
//  Created by Santhosh on 29/03/22.
//

import UIKit

class AuthorViewController:UITableViewController{
    
    var authors:[Author] = []
    override func viewDidLoad() {
        super.viewDidLoad()
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
        NewQuoteViewController.authorText = authors[indexPath.row].name!
        dismiss(animated: true, completion: nil)
    }
}

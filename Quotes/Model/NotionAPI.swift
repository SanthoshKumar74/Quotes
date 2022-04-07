//
//  NotionAPI.swift
//  Quotes
//
//  Created by Santhosh on 29/03/22.
//

import Foundation
import SwiftyJSON
import CoreData

class NotionAPI
{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var Quote : [Quotes] = []
    var categories : [Category] = []
    var authors : [Author] = []
   
    
     func retriveData()
    {
       deleteCoreData()
        let headers = [
          "Accept": "application/json",
          "Notion-Version": "2022-02-22",
          "Content-Type": "application/json",
          "Authorization": "Bearer secret_qRBPjunNDhcYCkP5WhZ9HcZbZOsTf2lykgZeQewxdyS"
        ]
            
//        let parameters = [
//                "filter": [
//                    "property": "Category",
//                    "multi_select": [
//                        "contains": "Life"
//                    ]
//                ],
//          "page_size": 100
//        ] as [String : Any]


        let url = URL(string: "https://api.notion.com/v1/databases/9c07dc74b3444b7aaaea6fba7a9405fd/query")
        var recquest = URLRequest(url: url!)
        //let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        recquest.httpMethod = "POST"
        recquest.allHTTPHeaderFields = headers
        //recquest.httpBody = postData! as Data

        let session = URLSession(configuration: .default)
        let task =  session.dataTask(with: recquest) { [self] (data, response, error) in
           if let safeData = data {
            
               let json = try! JSON(data: safeData)
               let results = json["results"]
               print("NotionAPI results count")
               print(results.count)
               for result in results
               {
                   let newQuote = Quotes(context:context)
                   let newAuthor = Author(context: context)
                   let newCategory = Category(context: context)
                           newQuote.quote = result.1["properties"]["Quote"]["title"][0]["text"]["content"].string
                           newAuthor.name =  result.1["properties"]["Author"]["multi_select"][0]["name"].string
                           newQuote.authorCategory = newAuthor
                           newCategory.name = result.1["properties"]["Category"]["multi_select"][0]["name"].string
                           newQuote.parentCategory = newCategory
                   }
                  
                   
                   }
                   //self.Quote.append(quote)
         
           }
        task.resume()
        try! context.save()
    
//        return categories
        
    }
    
    func updateData(author: String, Quote: String, Category: String ) {
        
        let headers = [
          "Accept": "application/json",
          "Notion-Version": "2022-02-22",
          "Content-Type": "application/json",
          "Authorization": "Bearer secret_qRBPjunNDhcYCkP5WhZ9HcZbZOsTf2lykgZeQewxdyS"
        ]
        
        
        let parameters = [
          "page_size": 100,
          "filter": [
            "property": "Quote",
            "rich_text": ["contains": Quote]
          ]
        ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
       
        
        let url = URL(string: "https://api.notion.com/v1/databases/9c07dc74b3444b7aaaea6fba7a9405fd/query")
        var recquest = URLRequest(url: url!)
        recquest.httpBody = postData! as Data
        recquest.httpMethod = "POST"
        recquest.allHTTPHeaderFields = headers
        
        let session = URLSession(configuration: .default)

        let task =  session.dataTask(with: recquest) { (data, response, error) in
           if let safeData = data {
               
              
            
               let json = try! JSON(data: safeData)
               let results = json["results"]
               print(results)
            
              if results != []
               {
               //print(results[0]["id"].stringValue)
                  if author == "" {
               self.updatePage(id: results[0]["id"].stringValue, author: "", Quote: Quote, category: Category)
                  }
                  else{
                      self.updatePage(id: results[0]["id"].stringValue, author: author, Quote: Quote, category: Category)
                  }
               }else
               {
                   self.addPage(quote: Quote, author: author, category: Category)
               }
        
    }
           
            
            
        
}
        task.resume()
        
    }
    
    
    func updatePage(id:String,author:String,Quote:String,category:String)
    {
        print("Author\(author)")
        let headers = [
          "Accept": "application/json",
          "Notion-Version": "2022-02-22",
          "Content-Type": "application/json",
          "Authorization": "Bearer secret_qRBPjunNDhcYCkP5WhZ9HcZbZOsTf2lykgZeQewxdyS"
        ]
        
        let parameters = [
            "parent": ["type" : "database_id" ,
                       "database_id" : "9c07dc74-b344-4b7a-aaea-6fba7a9405fd"],
            "properties" : [ "Author" : ["type" :"multi_select", "multi_select" : [ ["name" : author ]]],
            "Category" : ["type" :"multi_select", "multi_select" : [ ["name" : category ]] ],
            "Quote": ["title": [[ "type": "text",
                                       "text": ["content": Quote]]]]
        ]] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
       
        
        let url = URL(string: "https://api.notion.com/v1/pages/\(id)")
        var recquest = URLRequest(url: url!)
        recquest.httpBody = postData! as Data
        recquest.httpMethod = "PATCH"
        recquest.allHTTPHeaderFields = headers
        
        let session = URLSession(configuration: .default)
        let task =  session.dataTask(with: recquest) { (data, response, error) in
           if let safeData = data {
               let json = try! JSON(data: safeData)
               //print(json)
               
        
    }
                
    }
        task.resume()
    }
    
    
    
    func addPage(quote:String,author:String,category:String)
    {
        
        let headers = [
          "Accept": "application/json",
          "Notion-Version": "2022-02-22",
          "Content-Type": "application/json",
          "Authorization": "Bearer secret_qRBPjunNDhcYCkP5WhZ9HcZbZOsTf2lykgZeQewxdyS"
        ]
        
        let parameters = [
            "parent": ["type" : "database_id" ,
                       "database_id" : "9c07dc74-b344-4b7a-aaea-6fba7a9405fd"],
            "properties" : [ "Author" : ["type" :"multi_select", "multi_select" : [ ["name" : author ]]],
            "Category" : ["type" :"multi_select", "multi_select" : [ ["name" : category ]] ],
            "Quote": ["title": [[ "type": "text",
                                       "text": ["content": quote ]]]]
        ]] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
       
        
        let url = URL(string: "https://api.notion.com/v1/pages")
        var recquest = URLRequest(url: url!)
        recquest.httpBody = postData! as Data
        recquest.httpMethod = "POST"
        recquest.allHTTPHeaderFields = headers
        
        let session = URLSession(configuration: .default)
        let task =  session.dataTask(with: recquest) { (data, response, error) in
           if let safeData = data {
               let json = try! JSON(data: safeData)
            //   print(json)
               
        
    }
                
    }
        task.resume()
    }
        
    }


extension NotionAPI
{
    func deleteCoreData()
    {
        // Get a reference to a NSPersistentStoreCoordinator
        let context =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let authorRecquest : NSFetchRequest<NSFetchRequestResult>
        authorRecquest = NSFetchRequest(entityName: "Author")
        let categoryRecquest : NSFetchRequest<NSFetchRequestResult>
        categoryRecquest = NSFetchRequest(entityName: "Category")
        let quoteRecquest : NSFetchRequest<NSFetchRequestResult>
        quoteRecquest = NSFetchRequest(entityName: "Quotes")
        
        let deleteauthorRequest = NSBatchDeleteRequest(
            fetchRequest: authorRecquest
        )
        
        let deleteCategoryRequest = NSBatchDeleteRequest(
            fetchRequest: categoryRecquest
        )
        
        let deletequotesRequest = NSBatchDeleteRequest(
            fetchRequest: quoteRecquest
        )
        do{
         try context.execute(deleteauthorRequest)
         try context.execute(deletequotesRequest)
         try context.execute(deleteCategoryRequest)
        }
        catch{
            
        }


}
}


extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}


//MARK: Delete Authors
extension NotionAPI
{
    func deleteAuthor(author:String)
    {
        
        let headers = [
          "Accept": "application/json",
          "Notion-Version": "2022-02-22",
          "Content-Type": "application/json",
          "Authorization": "Bearer secret_qRBPjunNDhcYCkP5WhZ9HcZbZOsTf2lykgZeQewxdyS"
        ]
        
        
                let parameters = [
                        "filter": [
                            "property": "Author",
                            "multi_select": [
                                "contains": author
                            ]
                        ],
                  "page_size": 100
                ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
       
        
        let url = URL(string: "https://api.notion.com/v1/databases/9c07dc74b3444b7aaaea6fba7a9405fd/query")
        var recquest = URLRequest(url: url!)
        recquest.httpBody = postData! as Data
        recquest.httpMethod = "POST"
        recquest.allHTTPHeaderFields = headers
        
        let session = URLSession(configuration: .default)

        let task =  session.dataTask(with: recquest) { (data, response, error) in
           if let safeData = data {
               
              
            
               let json = try! JSON(data: safeData)
               let results = json["results"]
               //print(results)
               for result in results{
                   print(result.1["id"])
                   self.deletePage(id:result.1["id"].stringValue)
               }
            
            
    }
}
        task.resume()
        
    }
    

    func deletePage(id:String)
    {
        let headers = [
          "Accept": "application/json",
          "Notion-Version": "2022-02-22",
          "Authorization": "Bearer secret_qRBPjunNDhcYCkP5WhZ9HcZbZOsTf2lykgZeQewxdyS"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.notion.com/v1/blocks/\(id)")! as URL)
                                                
                                            
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
              print("error")
            print(error)
          } else {
            let httpResponse = response as? HTTPURLResponse
              print("Succeed")
            print(httpResponse)
          }
        })

        dataTask.resume()
    }
    
    func deleteQuote(quote:String)
    {
        print(quote)
        let headers = [
          "Accept": "application/json",
          "Notion-Version": "2022-02-22",
          "Content-Type": "application/json",
          "Authorization": "Bearer secret_qRBPjunNDhcYCkP5WhZ9HcZbZOsTf2lykgZeQewxdyS"
        ]
        
        
        let parameters = [
          "page_size": 100,
          "filter": [
            "property": "Quote",
            "rich_text": ["contains": quote]
          ]
        ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
       
        
        let url = URL(string: "https://api.notion.com/v1/databases/9c07dc74b3444b7aaaea6fba7a9405fd/query")
        var recquest = URLRequest(url: url!)
        recquest.httpBody = postData! as Data
        recquest.httpMethod = "POST"
        recquest.allHTTPHeaderFields = headers
        
        let session = URLSession(configuration: .default)

        let task =  session.dataTask(with: recquest) { (data, response, error) in
           if let safeData = data {
               
              
            
               let json = try! JSON(data: safeData)
               let results = json["results"]
               print(results)
               self.deletePage(id: results[0]["id"].stringValue)       
}
     
        
    }
        task.resume()
    }
}





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
   
    
     func retriveData()-> [Category]
    {
       
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().sync{
        let headers = [
          "Accept": "application/json",
          "Notion-Version": "2022-02-22",
          "Content-Type": "application/json",
          "Authorization": "Bearer secret_qRBPjunNDhcYCkP5WhZ9HcZbZOsTf2lykgZeQewxdyS"
        ]
            
            do{
                try Quote = context.fetch(Quotes.fetchRequest()) as [Quotes]
                try categories = context.fetch(Category.fetchRequest()) as [Category]
                try authors = context.fetch(Author.fetchRequest()) as [Author]
                
            }catch
            {
                
            }
            
            let quotesName = Quote.compactMap({$0.quote})
            let authorName = authors.compactMap({$0.name})
            let categoryName = categories.compactMap({$0.name})
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
               //print(results)
               for result in results
               {
                   var oldQuote = Quotes()
                   var newQuote = Quotes(context:context)
                   
                   if quotesName.contains(result.1["properties"]["Quote"]["title"][0]["text"]["content"].string!)
                   {
                   for quote in Quote {
                       if quote.quote == result.1["properties"]["Quote"]["title"][0]["text"]["content"].string
                       {
                           //oldQuote.quote = result.1["properties"]["Quote"]["title"][0]["text"]["content"].string
                           
                       }
                   }
                   }else{
                    
                           newQuote.quote = result.1["properties"]["Quote"]["title"][0]["text"]["content"].string
                       
                       
                   }
                   
                   if authorName.contains( result.1["properties"]["Author"]["multi_select"][0]["name"].string!)
                   {
                   for author in authors {
                       if author.name ==  result.1["properties"]["Author"]["multi_select"][0]["name"].string
                       {
                           //oldAuthor.name =  result.1["properties"]["Author"]["multi_select"][0]["name"].string
                          // oldQuote.authorCategory = oldAuthor
                           
                       }
                   }
                   }
                   else
                   {
                               let newAuthor = Author(context: context)
                           newAuthor.name =  result.1["properties"]["Author"]["multi_select"][0]["name"].string
                           newQuote.authorCategory = newAuthor
                       
                       
                   }
                   
                   if categoryName.contains(result.1["properties"]["Category"]["multi_select"][0]["name"].string!)
                   {
                   for category in categories {
                       if category.name == result.1["properties"]["Category"]["multi_select"][0]["name"].string
                       {
                          // oldCatgory.name = result.1["properties"]["Category"]["multi_select"][0]["name"].string
                          // oldQuote.parentCategory = oldCatgory
                           
                       }
                   }
                   }
                   else
                   {
                     
                               let newCategory = Category(context: context)
                           newCategory.name = result.1["properties"]["Category"]["multi_select"][0]["name"].string
                           newQuote.parentCategory = newCategory
                       
                       
                   }
                  
                   
                   }
                   //self.Quote.append(quote)
                   try! self.context.save()
           }
            do{
        try categories = context.fetch(Category.fetchRequest()) as [Category]
    }catch{
        print("error Loading Data\(error)")
    }
            for category in categories {
                print(category.name)
            }
           
           
        }
      
        task.resume()
            group.leave()}
        
        group.wait()
        return categories
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
            
              if results != []
               {
               //print(results[0]["id"].stringValue)
               self.updatePage(id: results[0]["id"].stringValue, author: author, Quote: Quote, category: Category)
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



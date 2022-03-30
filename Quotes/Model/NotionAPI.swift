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
    //var Quote : [Quotes] = []
    var categories : [Category] = []
    var authors : [Author] = []
    
     func retriveData()
    {
        do{
            try categories = context.fetch(Category.fetchRequest()) as [Category]
        }catch{
            print("error Loading Data\(error)")
        }
        do{
            try authors = context.fetch(Author.fetchRequest()) as [Author]
        }catch{
            print("error Loading Data\(error)")
        }
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
       let task =  session.dataTask(with: recquest) { (data, response, error) in
           if let safeData = data {
            
               let json = try! JSON(data: safeData)
               let results = json["results"]
               print(results)
             
//
//               for result in results
//               {
//                   let quote = Quotes(context: self.context)
//
//                   quote.quote = result.1["properties"]["Quote"]["title"][0]["text"]["content"].string
//
//                   for category in self.categories {
//                       if category.name ==  result.1["properties"]["Category"]["multi_select"][0]["name"].string
//                       {
//                           print(result.1["properties"]["Category"]["multi_select"][0]["name"].string)
//                           quote.parentCategory = category
//
//
//                       } else
//                       {
//                           print(result.1["properties"]["Category"]["multi_select"][0]["name"].string
//)
//                           let category = Category(context: self.context)
//                           category.name = result.1["properties"]["Category"]["multi_select"][0]["name"].string
//                           quote.parentCategory = category
//
//                       }
//
//                   }
//
//                   for author in self.authors {
//                       if author.name == result.1["properties"]["Author"]["multi_select"][0]["name"].string
//                       {
//                           print(result.1["properties"]["Author"]["multi_select"][0]["name"].string)
//                           quote.authorCategory = author
//
//                       }
//                       else
//                       {
//                           print(result.1["properties"]["Author"]["multi_select"][0]["name"].string)
//                           let author = Author(context: self.context)
//                           author.name = result.1["properties"]["Author"]["multi_select"][0]["name"].string
//                           quote.authorCategory = author
//
//                       }
//                   }
//                   //self.Quote.append(quote)
//                   try! self.context.save()
//
//               }
//
           }
        }
        task.resume()
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
               
               self.updatePage(id: results[0]["id"].stringValue, author: author, Quote: Quote, category: Category)
        
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
            "Category" : ["type" :"multi_select", "multi_select" : [ ["name" : "Kumar" ]] ],
            "Quote": ["title": [[ "type": "text",
                                       "text": ["content": "Santhosh"]]]]
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
               print(json)
               
        
    }
                
    }
        task.resume()
    }

}

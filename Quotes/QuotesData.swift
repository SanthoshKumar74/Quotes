//
//  Quotes Data.swift
//  Quotes
//
//  Created by Santhosh on 17/03/22.
//

import UIKit

class QuotesData{
    var quote:String
    var author:String
    var category:String
    
    init(quote:String,author:String,category:String){
        self.quote = quote
        self.author = author
        self.category = category
    }





   static var testData = [QuotesData(quote: "If you want to read about love and marriage you've got to buy two separate books.", author: "Alan King", category: "Companionship"),
                    QuotesData(quote: "Love is an act of endless forgiveness, a tender look which becomes a habit.", author: "Peter Ustinov", category: "Companionship"),
                    QuotesData(quote: "My most brilliant achievement was my ability to be able to persuade my wife to marry me.", author: "Winston Churchill", category: "Companionship"),
                    QuotesData(quote: "There are two levers for moving men - interest and fear.", author: "Napoleon Bonaparte", category: "Leadership"),
                    QuotesData(quote: "I suppose leadership at one time meant muscles; but today it means getting along with people.", author: "Indra Gandhi", category: "Leadership"),
                    QuotesData(quote: "The journey of a thousand miles begins with one step.", author: "Lao Tzu", category: "Motivation"),
                    QuotesData(quote: "That which does not kill us makes us stronger.", author: "Friedrich Nietzsche", category: "Motivation"),
                    QuotesData(quote: "The courage of life is often a less dramatic spectacle than the courage of a final moment, but it is no less a magnificent mixture of triumph and tragedy. A man does what he must- in spite of personal consequences, in spite of obstacles and dangers and pressures-and that is the basis of all morality.", author: "John F. Kennedy", category: "Life"),
                    QuotesData(quote: "Let us not look back in anger, nor forward in fear, but around us in awareness.", author: "James Thurber", category: "Life"),
                    QuotesData(quote: "It takes courage to know when you ought to be afraid.", author: "James A. Michener", category: "Life")]
}

class Category
{
    var category:QuotesData
    var name: String
    
    init(name:String,category:QuotesData){
        self.name = name
        self.category = category
    }
    
    static var testData = [Category(name: "Companionship", category: QuotesData.testData[0]),
                           Category(name: "Companionship", category: QuotesData.testData[1]),
                           Category(name: "Companionship", category: QuotesData.testData[2]),
                           Category(name: "Leadership", category: QuotesData.testData[3]),
                           Category(name: "Leadership", category: QuotesData.testData[4]),
                           Category(name: "Motivation", category: QuotesData.testData[5]),
                           Category(name: "Motivation", category: QuotesData.testData[6]),
                           Category(name: "Life", category: QuotesData.testData[7]),
                           Category(name: "Life", category: QuotesData.testData[8]),
                           Category(name: "Life", category: QuotesData.testData[9])]
}

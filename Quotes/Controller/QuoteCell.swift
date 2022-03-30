//
//  QuoteCellTableViewCell.swift
//  Quotes
//
//  Created by Santhosh on 18/03/22.
//

import UIKit

class QuoteCell: UITableViewCell {
    
    @IBOutlet var quoteView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configure(quote:Quotes)
    {
        print(quote.quote)
        quoteView.text = quote.quote
        
    }
}

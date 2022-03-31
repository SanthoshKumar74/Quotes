//
//  QuoteCellTableViewCell.swift
//  Quotes
//
//  Created by Santhosh on 18/03/22.
//

import UIKit

class QuoteCell: UITableViewCell {
    

    @IBOutlet var quoteView: UITextView!
    @IBOutlet var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configure(quote:Quotes)
    {
        quoteView.text = quote.quote
        authorLabel.text = quote.authorCategory?.name
        
    }
}

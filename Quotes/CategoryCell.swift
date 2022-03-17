//
//  CategoryCell.swift
//  Quotes
//
//  Created by Santhosh on 17/03/22.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    
    @IBOutlet var categoryImage: UIImageView!
    
    @IBOutlet var categoryLabel: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func configure(category:Category,image:UIImage){
        categoryLabel.text = category.name
        categoryImage.image = image
    }
    
}

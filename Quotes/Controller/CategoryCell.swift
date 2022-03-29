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
        DispatchQueue.main.async {
            if let name = category.name{
                self.categoryLabel.text = name
                self.categoryImage.image = image
            }
        }
        
    }
    
}

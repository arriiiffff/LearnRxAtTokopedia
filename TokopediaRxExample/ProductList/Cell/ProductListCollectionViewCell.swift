//
//  ProductListCollectionViewCell.swift
//  TokopediaRxExample
//
//  Created by GITS on 09/11/19.
//  Copyright © 2019 Muhammad Arif. All rights reserved.
//

import UIKit

struct ProductListCollectionCellData {
    let imageUri: String
    let name: String
    let price: String
}

class ProductListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with data: ProductListCollectionCellData) {
        self.labelProductName.text = data.name
        self.labelPrice.text = data.price
        self.getImage(imageUrl: data.imageUri)
    }
    
    func getImage(imageUrl: String) {
        let url = NSURL(string:imageUrl)
        let imagedata = NSData.init(contentsOf: url! as URL)

        if imagedata != nil {
            self.imageProduct.image = UIImage(data:imagedata! as Data)
        }
    }
}

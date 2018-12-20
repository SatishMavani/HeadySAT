//
//  ProductCollectionVC.swift
//  HeadySAT
//
//  Created by Satish Mavani on 19/12/18.
//  Copyright © 2018 satishmavani. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProductViewCell"

class ProductCollectionVC: UICollectionViewController {
    
    var category : Category!
    var productArray : [CategoryProduct] = []
    var selectedProduct : CategoryProduct!

    override func viewDidLoad() {
        super.viewDidLoad()
        productArray = category.products
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductViewCell
    
        let product = self.productArray[indexPath.row]
        
        cell.productName.text = product.name
        cell.dateAdded.text = product.dateAdded
        cell.lblID.text = "\(product.id)"
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = self.productArray[indexPath.row]
        self.performSegue(withIdentifier: "product", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProductDetailVC
        vc.product = selectedProduct
    }

}

//
//  ProductDetailVC.swift
//  HeadySAT
//
//  Created by Satish Mavani on 20/12/18.
//  Copyright © 2018 satishmavani. All rights reserved.
//

import UIKit

enum collectionType: Int {
    case sizesCV = 100
    case colorsCV = 200
}

class ProductDetailVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var lblID: UILabel!
    var product : CategoryProduct!
    var selectedVariant : Variant!
    var variants : [Variant]!
    var colors : [String]!
    var sizes : [Int]!
    var selectedColor : String!
    var selectedSize : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        variants = self.product!.variants
        
        let colorMap = Set(variants.map { $0.color })
        colors = Array(colorMap) as [String]
        if colors.count>0{
            selectedColor = colors.first
        }
        
        
        let sizeMap = Set(variants.map { $0.size })
        sizes = Array(sizeMap) as? [Int]
        if sizes.count>0{
        selectedSize = sizes.first
        }
        
        if let id = self.product?.id {
            self.lblID.text = "\(id)"
        }
        self.updateSelectedProductPrice()
    }
    
    func updateSelectedProductPrice()  {
        let variant = variants.filter{ $0.size == selectedSize && $0.color == selectedColor}
        
        if let price = variant.first?.price{
            selectedVariant = variant.first
            self.productPrice.text = "₹\(price)"
        }
    }
    
    @IBAction func buyProduct(_ sender: Any) {
        self.performSegue(withIdentifier: "payment", sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == collectionType.colorsCV.rawValue{
            return colors.count
        }
        else{
            return sizes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let details = cell.viewWithTag(1) as! UILabel
        details.layer.borderColor = UIColor.gray.cgColor
        details.layer.masksToBounds = true
        
        if collectionView.tag == collectionType.colorsCV.rawValue{
            details.text = "\(colors[indexPath.row])"
            if let co = self.selectedColor {
               if co == details.text{
                    details.backgroundColor = UIColor.blue
                    details.textColor = UIColor.white
                }
                else{
                    details.backgroundColor = UIColor.white
                    details.textColor = UIColor.lightGray
                }
            }
        }
        else{
            details.text = "\(sizes[indexPath.row])"
            
            if let si = self.selectedSize {
                if "\(si)" == details.text{
                    details.backgroundColor = UIColor.blue
                    details.textColor = UIColor.white
                }
                else{
                    details.backgroundColor = UIColor.white
                    details.textColor = UIColor.lightGray
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == collectionType.colorsCV.rawValue{
            self.selectedColor = colors[indexPath.row]
        }
        else{
            self.selectedSize = sizes[indexPath.row]
        }
        self.updateSelectedProductPrice()
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let payment = segue.destination as! PaymentVC
        payment.product = self.product;
        payment.variant = self.selectedVariant
    }

    

}

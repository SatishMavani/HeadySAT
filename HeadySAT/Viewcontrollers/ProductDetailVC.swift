//
//  ProductDetailVC.swift
//  HeadySAT
//
//  Created by Satish Mavani on 20/12/18.
//  Copyright © 2018 satishmavani. All rights reserved.
//

import UIKit

enum CollectionType: Int {
    case sizesCV = 100
    case colorsCV = 200
}

class ProductDetailVC: UIViewController {
    
    @IBOutlet weak private var productPrice: UILabel!
    @IBOutlet weak private var lblID: UILabel!
    @IBOutlet weak private var viewSize: UIView!
    @IBOutlet weak private var viewColor: UIView!
    
    var product: CategoryProduct!
    private var selectedVariant: Variant!
    private var variants: [Variant]!
    private var colors: [String]!
    private var sizes: [Int]!
    private var selectedColor: String!
    private var selectedSize: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
    }
    
    private func setupOnLoad() {
        self.title = product.name
        variants = self.product?.variants
        
        let colorMap = Set(variants.map { $0.color })
        colors = Array(colorMap) as [String]
        if colors.count > 0 {
            selectedColor = colors.first
        }
        
        let sizeMap = Set(variants.map { $0.size })
        sizes = Array(sizeMap) as? [Int]
        
        if sizes != nil {
            if sizes.count > 0 {
                selectedSize = sizes.first
            }
        } else {
            self.viewSize.isHidden = true
            self.viewColor.layer.borderWidth = 1
        }
        
        if let productID = self.product?.id {
            self.lblID.text = "\(productID)"
        }
        self.updateSelectedProductPrice()
    }
    
    func updateSelectedProductPrice() {
        let variant = variants.filter { $0.size == selectedSize && $0.color == selectedColor}
        
        if let price = variant.first?.price {
            selectedVariant = variant.first
            self.productPrice.text = "₹\(price)"
        }
    }
    
    @IBAction func buyProduct(_ sender: Any) {
        self.performSegue(withIdentifier: "payment", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let paymentVC = segue.destination as? PaymentVC {
            paymentVC.product = self.product
            paymentVC.variant = self.selectedVariant
        }
    }
    
}

extension ProductDetailVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let details = cell.viewWithTag(1) as? UILabel else { return UICollectionViewCell() }
        details.layer.borderColor = UIColor.gray.cgColor
        details.layer.masksToBounds = true
        
        if collectionView.tag == CollectionType.colorsCV.rawValue {
            details.text = "\(colors[indexPath.row])"
            if let selectedColor = self.selectedColor {
                if selectedColor == details.text {
                    details.backgroundColor = UIColor.blue
                    details.textColor = UIColor.white
                } else {
                    details.backgroundColor = UIColor.white
                    details.textColor = UIColor.lightGray
                }
            }
        } else {
            details.text = "\(sizes[indexPath.row])"
            
            if let selectedSize = self.selectedSize {
                if "\(selectedSize)" == details.text {
                    details.backgroundColor = UIColor.blue
                    details.textColor = UIColor.white
                } else {
                    details.backgroundColor = UIColor.white
                    details.textColor = UIColor.lightGray
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == CollectionType.colorsCV.rawValue {
            return colors.count
        } else {
            if sizes != nil {
                return sizes.count
            }
            return 0
        }
    }
    
}

extension ProductDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == CollectionType.colorsCV.rawValue {
            self.selectedColor = colors[indexPath.row]
        } else {
            self.selectedSize = sizes[indexPath.row]
        }
        self.updateSelectedProductPrice()
        collectionView.reloadData()
    }
}

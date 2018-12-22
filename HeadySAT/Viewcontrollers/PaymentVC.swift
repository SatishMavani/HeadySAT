//
//  PaymentVC.swift
//  HeadySAT
//
//  Created by Satish Mavani on 20/12/18.
//  Copyright © 2018 satishmavani. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {
    
    @IBOutlet weak private var lblID: UILabel!
    @IBOutlet weak private var lblSize: UILabel!
    @IBOutlet weak private var lblColor: UILabel!
    @IBOutlet weak private var lblPrice: UILabel!
    @IBOutlet weak private var lblTax: UILabel!
    @IBOutlet weak private var lblTotal: UILabel!
    
    var product: CategoryProduct!
    var variant: Variant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
    }
    
    private func setupOnLoad() {
        lblID.text = "\(product.id)"
        if let size = variant?.size {
            lblSize.text = "Size : \(size)"
        } else {
            lblSize.text = ""
        }
        if let color = variant?.color {
            lblColor.text = "Color : \(color)"
        }
        if let price = variant?.price {
            lblPrice.text = "Price : ₹\(price)"
            
            if let tax = product?.tax.value {
                let tax = (Double)(price)*(tax/100)
                lblTax.text = String(format: "%@(%.2f) : ₹%.2f", product.tax.name, product.tax.value, tax)
                
                let total = Double(variant.price) + tax
                lblTotal.text = String(format: "Total : ₹%.2f", total)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

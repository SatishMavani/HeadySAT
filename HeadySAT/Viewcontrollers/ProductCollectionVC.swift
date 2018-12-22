//
//  ProductCollectionVC.swift
//  HeadySAT
//
//  Created by Satish Mavani on 19/12/18.
//  Copyright © 2018 satishmavani. All rights reserved.
//

import UIKit

public enum sortOption {
    case MostViewed
    case MostOrdered
    case MostShared
}

class ProductCollectionVC: UICollectionViewController {
    
    private let reuseIdentifier = "ProductViewCell"
    private var productArray: [CategoryProduct] = []
    private var selectedProduct: CategoryProduct!
    public var isFromCategory : Bool = true
    var category: Category!
    var ranking: Ranking!
    var sortedArray : [RankingProduct]!
    var sortTyep : sortOption = .MostViewed
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
    }
    
    private func setupOnLoad() {
        
        if isFromCategory {
            productArray = category.products
            self.title = category.name
        }
        else{
            self.title = ranking.ranking
            self.sortAndFilterProduct()
        }
    }
    
    func sortAndFilterProduct (){
        
        switch sortTyep {
        case .MostViewed:
            sortedArray = ranking.products.sorted(by: { $0.viewCount! > $1.viewCount! })
        case .MostOrdered:
            sortedArray = ranking.products.sorted(by: { $0.orderCount! > $1.orderCount! })
        default:
            sortedArray = ranking.products.sorted(by: { $0.shares! > $1.shares! })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productDetailVC = segue.destination as? ProductDetailVC {
            productDetailVC.product = selectedProduct
        }
    }
}

extension ProductCollectionVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFromCategory {
            return self.productArray.count
        }
        else{
            return self.sortedArray.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                         for: indexPath) as? ProductViewCell {
            
            var product : CategoryProduct
            if isFromCategory{
                product = self.productArray[indexPath.row]
            }
            else{
                let foundProduct = DataSource.shared.categoryProducts.filter{ $0.id == sortedArray[indexPath.row].id}
                product = foundProduct.first ?? DataSource.shared.categoryProducts.first!
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            guard let date = dateFormatter.date(from: product.dateAdded) else {
                fatalError()
            }
            print(date)
            
            let timestamp = date.timeIntervalSince1970
            
            cell.productName.text = product.name
            cell.dateAdded.text = product.dateAdded
            cell.lblID.text = "\(product.id)"
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ProductCollectionVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = self.productArray[indexPath.row]
        self.performSegue(withIdentifier: "product", sender: self)
    }
}

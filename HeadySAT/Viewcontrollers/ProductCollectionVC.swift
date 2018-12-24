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
          
            cell.productName.text = product.name
            cell.lblID.text = "\(product.id)"
            cell.dateAdded.text = self.timeAgoStringFromDate(date: self.formatString(dateSring: product.dateAdded))
            return cell
        }
        return UICollectionViewCell()
    }
    
    func formatString(dateSring: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = dateFormatter.date(from: dateSring) else {
            let curDate = Date()
            return curDate
        }
        return date
        
    }
    
    func timeAgoStringFromDate(date: Date) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        
        let now = Date()
        
        let calendar = NSCalendar.current
        let components1: Set<Calendar.Component> = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        let components = calendar.dateComponents(components1, from: date, to: now)
        
        if components.year ?? 0 > 0 {
            formatter.allowedUnits = .year
        } else if components.month ?? 0 > 0 {
            formatter.allowedUnits = .month
        } else if components.weekOfMonth ?? 0 > 0 {
            formatter.allowedUnits = .weekOfMonth
        } else if components.day ?? 0 > 0 {
            formatter.allowedUnits = .day
        } else if components.hour ?? 0 > 0 {
            formatter.allowedUnits = [.hour]
        } else if components.minute ?? 0 > 0 {
            formatter.allowedUnits = .minute
        } else {
            formatter.allowedUnits = .second
        }
        
        let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
        
        guard let timeString = formatter.string(for: components) else {
            return nil
        }
        return String(format: formatString, timeString)
    }
    
}

extension ProductCollectionVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProduct = self.productArray[indexPath.row]
        self.performSegue(withIdentifier: "product", sender: self)
    }
}

//
//  DataSource.swift
//  HeadySAT
//
//  Created by Satish Mavani on 21/12/18.
//  Copyright © 2018 satishmavani. All rights reserved.
//

import UIKit

class DataSource {
    static let shared = DataSource()
    private init() {
        addIndicator()
        downloadData()
    }
    
    func setUp() {
        print("Started . . .")
    }
    
    var resposeData: ResponseData?
    
    private let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    private func addIndicator() {
        if let controller = tab,
            let view = controller.view {
            indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            indicator.center = view.center
            view.addSubview(indicator)
            view.bringSubviewToFront(indicator)
        }
    }
    
    private func showProgress() {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    private func hideProgress() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private func downloadData() {
        
        let sharedSession = URLSession.shared
        
        if let url = URL(string: "https://stark-spire-93433.herokuapp.com/json") {
            // Create Request
            let request = URLRequest(url: url)
            
            showProgress()
            // Create Data Task
            sharedSession.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
                defer {
                    DispatchQueue.main.async {
                        self.refreshUI()
                    }
                }
                self.hideProgress()
                if error != nil {
                    print(error!.localizedDescription)
                }
                guard let data = data else { return }
                do {
                    self.resposeData = try JSONDecoder().decode(ResponseData.self, from: data)
                } catch let jsonError {
                    print(jsonError)
                }
            }).resume()
        }
    }
    
    private var tab: UITabBarController? {
        if let window = UIApplication.shared.windows.first,
            let controller = window.rootViewController as? UITabBarController {
            return controller
        }
        return nil
    }
    
    func refreshUI() {
        if let tabController = tab {
            
            for controller in tabController.children {
                if let nav = controller as? UINavigationController,
                    let first =  nav.viewControllers.first as? FirstViewController {
                    first.refreshUI()
                } else if let second = controller as? SecondViewController {
                    second.refreshUI()
                }
            }
        }
    }
}

extension DataSource {
    var categories: [Category] {
        if let resposeData = resposeData {
            return resposeData.categories
        }
        return []
    }
    
    var rankings: [Ranking] {
        if let resposeData = resposeData {
            return resposeData.rankings
        }
        return []
    }
    
    var categoryProducts: [CategoryProduct] {
        return categories.flatMap({ $0.products })
    }
}

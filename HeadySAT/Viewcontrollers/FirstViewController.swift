//
//  FirstViewController.swift
//  HeadySAT
//
//  Created by Satish Mavani on 19/12/18.
//  Copyright © 2018 satishmavani. All rights reserved.
//

import UIKit

import UIKit

class FirstViewController: UIViewController {
    private var selectedCategory: Category!
    @IBOutlet weak private var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        refreshUI()
        DataSource.shared.setUp()
    }
    
    private func setupOnLoad() {
        self.title = "Caterories"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productCollectionVC = segue.destination as? ProductCollectionVC {
            productCollectionVC.isFromCategory = true
            productCollectionVC.category = selectedCategory
        }
    }
    
    func refreshUI() {
        self.tableview?.reloadData()
    }
}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.shared.categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        let category = DataSource.shared.categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = "\(category.products.count)"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = DataSource.shared.categories[indexPath.row]
        self.performSegue(withIdentifier: "productList", sender: self)
    }
}

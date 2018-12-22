//
//  SecondViewController.swift
//  HeadySAT
//
//  Created by Satish Mavani on 19/12/18.
//  Copyright © 2018 satishmavani. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    private var selectedRow: Int = 0
    @IBOutlet weak private var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnLoad()
        refreshUI()
    }
    
    private func setupOnLoad() {
        self.title = "Ranking"
    }
    
    func refreshUI() {
        self.tableview?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productCollectionVC = segue.destination as? ProductCollectionVC {
            productCollectionVC.ranking = DataSource.shared.rankings[selectedRow]
            productCollectionVC.isFromCategory = false
            
            switch selectedRow {
            case 0:
                productCollectionVC.sortTyep = .MostViewed
            case 1:
                productCollectionVC.sortTyep = .MostOrdered
            default:
                productCollectionVC.sortTyep = .MostShared
            }
        }
    }
}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.shared.rankings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let rankingD = DataSource.shared.rankings[indexPath.row]
        cell.textLabel?.text = rankingD.ranking
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ atableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        atableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "productListRanking", sender: self)
    }
}

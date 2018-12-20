//
//  FirstViewController.swift
//  HeadySAT
//
//  Created by Satish Mavani on 19/12/18.
//  Copyright © 2018 satishmavani. All rights reserved.
//

import UIKit


class FirstViewController: UIViewController {
    
    var resposeData : ResponseData!
    var categories : [Category] = []
    var selectedCategory : Category!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.downloadData()
    }

    func downloadData(){
        
        let sharedSession = URLSession.shared
        
        if let url = URL(string: "https://stark-spire-93433.herokuapp.com/json") {
            // Create Request
            let request = URLRequest(url: url)
            
            // Create Data Task
            sharedSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(error!.localizedDescription)
                }
                
                guard let data = data else { return }
                //Implement JSON decoding and parsing
                do {
                    //Decode retrived data with JSONDecoder and assing type of Article object
                    self.resposeData = try JSONDecoder().decode(ResponseData.self, from: data)
                    self.categories = self.resposeData.categories
                    DispatchQueue.main.async {
                        self.tableview.reloadData()
                    }
                    
                } catch let jsonError {
                    print(jsonError)
                }
            }).resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ProductCollectionVC
        vc.category = selectedCategory
    }

}

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        let category = self.categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = "\(category.products.count)"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}



extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = self.categories[indexPath.row]
        self.performSegue(withIdentifier: "productList", sender: self)
    }
}

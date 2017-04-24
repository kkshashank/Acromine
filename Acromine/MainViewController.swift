//
//  MainViewController.swift
//  Acromine
//
//  Created by Shashank Kumar on 4/24/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleOfAcronym: UILabel!
    @IBOutlet weak var searchAcronymBTN: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var definitionsForAcronym = [String]()
    
    
    @IBAction func searchAcronymPressed(_ sender: CustomUIButton) {
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return definitionsForAcronym.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DefinitionCell") as? DefinitionTableViewCell else {return UITableViewCell()}
        cell.configureCell(title: definitionsForAcronym[indexPath.row])
        return cell
    }
}

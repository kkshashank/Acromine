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
    private var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func searchAcronymPressed(_ sender: CustomUIButton) {
        searchBar.isHidden = false
        tableView.isHidden = false
        searchBar.becomeFirstResponder()
        searchAcronymBTN.isHidden = true
        definitionsForAcronym = [String]()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        activityIndicator = activityIndicatorSetup(viewTo: view)
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        titleOfAcronym.text = "Acromine"
        definitionsForAcronym = [String]()
        tableView.reloadData()
        searchBar.text = nil
        searchBar.isHidden = true
        searchAcronymBTN.isHidden = false
        tableView.isHidden = true
        view.endEditing(true)
        activityIndicator.stopAnimating()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        definitionsForAcronym = [String]()
        if let userInput = searchBar.text, userInput != ""{
            fetchDefinitions(userInputIn: userInput)
        } else {
            titleOfAcronym.text = "Acromine"
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let userInput = searchBar.text, userInput != ""{
            fetchDefinitions(userInputIn: userInput)
        }
        view.endEditing(true)
    }
    
    private func fetchDefinitions(userInputIn: String){
        activityIndicator.startAnimating()
        titleOfAcronym.text = userInputIn.uppercased()
        definitionsForAcronym = [String]()
        DefinitionRequest.definitionRequestInstance.getDefinitions(definitionForAcronym: userInputIn, completion: { [weak weakSelf = self] (definitions, error) in
            guard let meanings = definitions else {
                weakSelf?.activityIndicator.stopAnimating()
                weakSelf?.alert(message: (error?.localizedDescription) ?? "Please try again!!!")
                return
            }
            weakSelf?.definitionsForAcronym = meanings
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.tableView.reloadData()
        })
    }
}

extension MainViewController{
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func alert(message: String){
        let alertController = UIAlertController(title: "Sorry, please try again!!!", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}


//
//  MainViewController.swift
//  Acromine
//
//  Created by Shashank Kumar on 4/24/17.
//  Copyright © 2017 Shashank. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleOfAcronymLbl: UILabel!
    @IBOutlet weak var searchAcronymBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var definitionsForAcronym = [String]()
    private var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        activityIndicator = activityIndicatorSetup(viewTo: view)
    }
    
    @IBAction func searchAcronymPressed(_ sender: CustomUIButton) {
        searchBar.isHidden = false
        tableView.isHidden = false
        searchBar.becomeFirstResponder()
        searchAcronymBtn.isHidden = true
        definitionsForAcronym = [String]()
    }
    
    //MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            cell.textLabel?.center.x += cell.contentView.bounds.width
        }, completion: nil)
    }
    
    //MARK: - TableViewDatasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return definitionsForAcronym.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let definitionCell = tableView.dequeueReusableCell(withIdentifier: DefinitionTableViewCell.reuseID()) as? DefinitionTableViewCell else { return UITableViewCell() }
        definitionCell.configureCell(title: definitionsForAcronym[indexPath.row])
        return definitionCell
    }
    
    //MARK: - SearchBarMethods
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        titleOfAcronymLbl.text = appTitle
        definitionsForAcronym = [String]()
        tableView.reloadData()
        searchBar.text = nil
        searchBar.isHidden = true
        searchAcronymBtn.isHidden = false
        tableView.isHidden = true
        view.endEditing(true)
        activityIndicator.stopAnimating()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        definitionsForAcronym = [String]()
        if searchText.isEmpty {
            titleOfAcronymLbl.text = appTitle
            tableView.reloadData()
        } else {
            fetchDefinitions(userInputIn: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let userInput = searchBar.text, !userInput.isEmpty {
            fetchDefinitions(userInputIn: userInput)
        }
        view.endEditing(true)
    }
    
    //MARK: - FetchDefinitionService
    
    private func fetchDefinitions(userInputIn: String) {
        activityIndicator.startAnimating()
        titleOfAcronymLbl.text = userInputIn.uppercased()
        definitionsForAcronym = [String]()
        DefinitionRequest.sharedDefinitionRequest.getDefinitions(definitionForAcronym: userInputIn, completion: { [weak weakSelf = self] (definitions, error) in
            guard let meanings = definitions else {
                weakSelf?.activityIndicator.stopAnimating()
                weakSelf?.alert(message: (error?.localizedDescription) ?? "Please try again!!!", titleAlert: "Sorry!!!")
                return
            }
            weakSelf?.definitionsForAcronym = meanings
            weakSelf?.activityIndicator.stopAnimating()
            weakSelf?.tableView.reloadData()
        })
    }
}

extension MainViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alert(message: String, titleAlert: String) {
        let alertController = UIAlertController(title: titleAlert, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}


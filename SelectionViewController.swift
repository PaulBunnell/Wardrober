//
//  SelectionViewController.swift
//  Wardrobe_Planner
//
//  Created by Paul Bunnell on 1/5/21.
//

import UIKit
import RealmSwift
import SCLAlertView

class SelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var tableClosetItems = [ClosetItem]()
    
    var filteredData = [ClosetItem]()
    
    public var outfit = Outfit()
    
    override func viewWillAppear(_ animated: Bool) {
        filteredData = []
        
        if searchBar.text == "" {
            filteredData = tableClosetItems
        }
        
        self.tableView.reloadData()
    }
    
//MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
// TableView
        tableView.allowsSelection = true
        tableView.dataSource = self
        tableView.delegate = self
        
// Search Bar
        searchBar.delegate = self
        
    }
    
// Deleting Data
    
    func deleteData() {
        realm.beginWrite()
        realm.delete(realm.objects(Outfit.self))
        try! realm.commitWrite()
    }
    
// Saving Data
    
    func saveData() {
        realm.beginWrite()
        realm.add(outfit.self)
        try! realm.commitWrite()
    }
    
//MARK: Done Button
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        // wont add just replaces
            
        guard let indexPaths = tableView.indexPathsForSelectedRows else {return print("NO SELECTED INDEX PATHS FOUND")}
        
        if indexPaths.count >= 3 {
            for indexPath in indexPaths {
                outfit.items.append(tableClosetItems[indexPath.row])
            }
            
            let alertView = SCLAlertView()
            let alertViewResponder = SCLAlertViewResponder(alertview: alertView)
            
            alertView.showCustom("Name", subTitle: "Add a name that describes the outfit.", color: UIColor.init(red: 230/255.0, green: 29/255.0, blue: 99/255.0, alpha: 1), icon: UIImage(named: "Outfit")!)
            let nameText = alertView.addTextField()
            nameText.backgroundColor = UIColor.lightGray
            nameText.textColor = UIColor.secondarySystemBackground
            alertViewResponder.setDismissBlock {
                
                if let outfitNameText = nameText.text {
                    self.outfit.name = outfitNameText
                }
                
                self.saveData()

                self.performSegue(withIdentifier: "unwindToOutfits", sender: nil)
            }
        }
        else {
            let errorAlert = SCLAlertView()
            
            errorAlert.showError("Error", subTitle: "Must choose 3 items.")
        
        }
        
    }
    
// Add Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        
        if searchText == "" {
            filteredData = tableClosetItems
        }
        else {
            for item in tableClosetItems {
                if item.name.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(item)
                }
            }
        }
        tableView.reloadData()
    }

}

//MARK: Table View Set Up
extension SelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as! SelectionTableViewCell
        
        cell.cellImage?.image = UIImage(data: filteredData[indexPath.row].image!, scale: 1.0)
        cell.cellLabel?.text = filteredData[indexPath.row].name
        
        cell.cellImage?.clipsToBounds = true
        cell.cellImage?.layer.cornerRadius = 7
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension SelectionViewController: UITableViewDelegate {

}

extension SelectionViewController: UISearchBarDelegate {
    
}



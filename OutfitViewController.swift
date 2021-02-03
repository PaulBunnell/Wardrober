//
//  OutfitViewController.swift
//  Wardrobe_Planner
//
//  Created by Paul Bunnell on 1/4/21.
//

import UIKit
import RealmSwift

class OutfitViewController: UIViewController {
    
    let realm = try! Realm()
    
    var outfits = [Outfit]()
    
    var filteredOutfits = [Outfit]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        
        filteredOutfits = []
        
        if searchBar.text == "" {
            filteredOutfits = outfits
        }
        
        self.collectionView.reloadData()
        
    }
    
//MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedObjects = realm.objects(Outfit.self)
        outfits.append(contentsOf: savedObjects)
      
        collectionView.register(OutfitCollectionViewCell.nib(), forCellWithReuseIdentifier: OutfitCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        searchBar.delegate = self
        
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.tintColor = UIColor.init(red: 230/255.0, green: 29/255.0, blue: 99/255.0, alpha: 1)

    }
    
// Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredOutfits = []
        
        if searchText == "" {
            filteredOutfits = outfits
        }
        else {
            for item in outfits {
                if item.name.lowercased().contains(searchText.lowercased()) {
                    filteredOutfits.append(item)
                }
            }
        }
        collectionView.reloadData()
    }
    
// Editing Cells
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView.cellForItem(at: indexPath) as? OutfitCollectionViewCell {
                    cell.isEditing = editing
                }
            }
        }
    }
    
    @IBAction func unwindFromTableView(segue: UIStoryboardSegue){
        guard let selectionViewController = segue.source as? SelectionViewController else {return}
        outfits.append(selectionViewController.outfit)
    }

}

extension OutfitViewController: UICollectionViewDelegate {

}

//MARK: Collection View Set Up
extension OutfitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredOutfits.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OutfitCollectionViewCell.identifier, for: indexPath) as! OutfitCollectionViewCell
        
        let outfit = filteredOutfits[indexPath.row]
        
        // need to guard let images
        
        cell.shirtImageView.image = UIImage(data: outfit.items[0].image!, scale: 1.0)
        
        cell.pantsImageView.image = UIImage(data: outfit.items[1].image!, scale: 1.0)
       
        cell.shoesImageView.image = UIImage(data: outfit.items[2].image!, scale: 1.0)
      
        cell.outfitCellLabel.text = outfit.name
        
        cell.shirtImageView.layer.cornerRadius = 7
        cell.pantsImageView.layer.cornerRadius = 7
        cell.shoesImageView.layer.cornerRadius = 7
        
        cell.shirtImageView.clipsToBounds = true
        cell.pantsImageView.clipsToBounds = true
        cell.shoesImageView.clipsToBounds = true
        
        cell.delegate = self
        
        return cell
    }

}

extension OutfitViewController: outfitCollectionCellDelegate{
    func delete(cell: OutfitCollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: cell){
            
            realm.beginWrite()
            realm.delete(outfits.remove(at: indexPath.row))
            try! realm.commitWrite()
            
            filteredOutfits.remove(at: indexPath.row)
            
            collectionView.reloadData()
            
        }
    }
}

extension OutfitViewController: UISearchBarDelegate {
    
}


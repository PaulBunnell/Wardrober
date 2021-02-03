//
//  ViewController.swift
//  Wardrobe_Planner
//
//  Created by Paul Bunnell on 12/17/20.
//

import UIKit
import RealmSwift
import BLTNBoard

class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    var closetItems = [ClosetItem]()
    
    var filteredClosetItems = [ClosetItem]()
    
    let saveIndexPath = IndexPath()
    
// Board Manager
    private lazy var boardManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "Get Started")
        item.image = UIImage(named: "floatingButton")
        item.actionButtonTitle = "Okay"
        item.descriptionText = "Use the plus icon to start your wardrobe!"
        item.actionHandler = { _ in
            self.didTapBoardOkay()
        }
        
        return BLTNItemManager(rootItem: item)
    }()
    
//MARK: Floating Button Set Up
            
    private let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
    
    private let addClosetItemButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
    
    private let addOutfitButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
    
    private let closetItemLabel = UILabel(frame: CGRect(x: 155, y: 430, width: 120, height: 15))
    
    private let outfitLabel = UILabel(frame: CGRect(x: 195, y: 481, width: 80, height: 15))
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        
        filteredClosetItems = []
        
        if searchBar.text ==  "" {
            filteredClosetItems = closetItems
        }
        
        self.collectionView.reloadData()
        
        if(!appDelegate.hasAlreadyLaunched){
            
            //set hasAlreadyLaunched to false
            
            appDelegate.setHasAlreadyLaunched()
                    
            // Display Bulletin Board
            
            boardManager.showBulletin(above: self)
        }
        
    }
    
//MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// Delete outfits from realm
//        deleteData()

// TEMPORARY FOR TESTING SHOULD BE DELETED
        boardManager.showBulletin(above: self)
        
// Loading Saved Data
        let savedObjects = realm.objects(ClosetItem.self)
        closetItems.append(contentsOf: savedObjects)
        
// Floating Button
        let image = UIImage(named: "floatingButton")
        button.frame = CGRect(x: 275, y: 515, width: 75, height: 75)
        button.setImage(image, for: .normal)
        button.layer.zPosition = 1
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
// Floating button to add closet item
        let closetItemImage = UIImage(named: "ClosetItemLabel")
        addClosetItemButton.frame = CGRect(x: 286.5, y: 515, width: 50, height: 50)
        addClosetItemButton.setImage(closetItemImage, for: .normal)
        addClosetItemButton.layer.zPosition = 1
        addClosetItemButton.addTarget(self, action: #selector(addClosetItemButtonTapped(_:)), for: .touchUpInside)
        
// Floating button to add outfit
        let outfitImage = UIImage(named: "OutfitLabel")
        addOutfitButton.frame = CGRect(x: 286.5, y: 515, width: 50, height: 50)
        addOutfitButton.setImage(outfitImage, for: .normal)
        addOutfitButton.layer.zPosition = 1
        addOutfitButton.addTarget(self, action: #selector(addOutfitButtonTapped(_:)), for: .touchUpInside)
        
        closetItemLabel.text = "New Closet Item"
        closetItemLabel.textAlignment = .left
        closetItemLabel.font = closetItemLabel.font.withSize(15)
        
        outfitLabel.text = "New Outfit"
        outfitLabel.textAlignment = .left
        outfitLabel.font = outfitLabel.font.withSize(15)
        
// Collection View Layouts
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 200)
        collectionView.collectionViewLayout = layout
        collectionView.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: MyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelectionDuringEditing = true
        collectionView.reloadData()
        

// Navigation Bar
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem?.tintColor = UIColor.init(red: 230/255.0, green: 29/255.0, blue: 99/255.0, alpha: 1)
        
// Search Bar
        searchBar.delegate = self
        
// Blur effect
        visualEffectView.frame = view.bounds
        visualEffectView.alpha = 0
        
// Dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
       
// Animation Functions
    func moveUp(view: UIView) {
        view.center.y -= 100
    }
    
    func moveUpLower(view: UIView) {
        view.center.y -= 50
    }
    
    func moveDown(view: UIView) {
        view.center.y += 100
    }
    
    func moveDownLess(view: UIView) {
        view.center.y += 50
    }
    
// Floating Board
    
    func didTapBoardOkay(){
        boardManager.dismissBulletin()
    }
    
// Deleting Data
    
    func deleteData(){
        realm.beginWrite()
        realm.delete(realm.objects(Outfit.self))
        try! realm.commitWrite()
    }
    
//MARK: Floating Action Button Logic
    var doubleTap: Bool! = false
    
    @objc private func addClosetItemButtonTapped(_ notification: NSNotification) {
        self.performSegue(withIdentifier: "showDetailViewController", sender: nil)
    }
    
    @objc private func addOutfitButtonTapped(_ notification: NSNotification){
        self.performSegue(withIdentifier: "showTableViewController", sender: nil)
        
    }
    
    @objc private func buttonClicked(_ notification: NSNotification) {
        
        switch doubleTap {
        case true:
            UIView.animate(withDuration: 0.15) {
                self.visualEffectView.alpha = 0
            } completion: { _ in
                self.visualEffectView.isHidden = true
            }
            UIView.animate(withDuration: 0.15) {
                self.moveDown(view: self.addClosetItemButton)
                self.moveDownLess(view: self.addOutfitButton)
            } completion: { _ in
                self.addOutfitButton.isHidden = true
                self.addClosetItemButton.isHidden = true
            }
            UIView.animate(withDuration: 0.15) {
                self.outfitLabel.alpha = 0.0
                self.closetItemLabel.alpha = 0.0
            } completion: { _ in
                self.outfitLabel.isHidden = true
                self.closetItemLabel.isHidden = true
            }
            doubleTap = false
        case false:
            if outfitLabel.isHidden || closetItemLabel.isHidden {
                UIView.animate(withDuration: 0.15) {
                    self.outfitLabel.alpha = 1.0
                    self.closetItemLabel.alpha = 1.0
                } completion: { _ in
                    self.outfitLabel.isHidden = false
                    self.closetItemLabel.isHidden = false
                }

            }
            else {
                view.addSubview(closetItemLabel)
                view.addSubview(outfitLabel)
            }
            if addClosetItemButton.isHidden || addOutfitButton.isHidden {
                addOutfitButton.isHidden = false
                addClosetItemButton.isHidden = false
                visualEffectView.isHidden = false
                UIView.animate(withDuration: 0.15) {
                    self.visualEffectView.alpha = 1
                }
                UIView.animate(withDuration: 0.15) {
                    self.moveUp(view: self.addClosetItemButton)
                    self.moveUpLower(view: self.addOutfitButton)
                }
                doubleTap = true
            }
            else {
                view.addSubview(addClosetItemButton)
                view.addSubview(addOutfitButton)
                view.insertSubview(visualEffectView, at: 1)
                UIView.animate(withDuration: 0.15) {
                    self.visualEffectView.alpha = 1
                }
                UIView.animate(withDuration: 0.15) {
                    self.moveUp(view: self.addClosetItemButton)
                    self.moveUpLower(view: self.addOutfitButton)
                }
                doubleTap = true
            }
        default:
            break
        }
        
    }
    
//MARK: Collection View Editing
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    
        if let indexPaths = collectionView?.indexPathsForVisibleItems {
            for indexPath in indexPaths {
                if let cell = collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell {
                    cell.isEditing = editing
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? SelectionViewController {
            destinationController.tableClosetItems = closetItems
        }
    }

//MARK: Unwind Actions
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue){
        guard let detailViewController = segue.source as? DetailViewController else {return}
        
        closetItems.append(detailViewController.closetItem)
        self.collectionView.reloadData()
    
    }
    
//MARK: Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         filteredClosetItems = []
        
        if searchText == ""  {
            filteredClosetItems = closetItems
        }
        else {
            for item in closetItems {
                
                if item.name.lowercased().contains(searchText.lowercased()) {
                    
                    filteredClosetItems.append(item)
                    
                }
            }
        }
        collectionView.reloadData()
    }
    
}

//MARK: Collection View Set Up

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
         
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return filteredClosetItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCell.identifier, for: indexPath) as! MyCollectionViewCell
        
        cell.cellImageView.image = UIImage(data: filteredClosetItems[indexPath.row].image!, scale: 1.0)
            cell.cellLabel.text = filteredClosetItems[indexPath.row].name
            
        
            cell.cellImageView.layer.cornerRadius = 7
            cell.cellImageView.clipsToBounds = true
        
            cell.delegate = self
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let padding: CGFloat =  50
            let collectionViewSize = collectionView.frame.size.width - padding

            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
}

extension ViewController: UIScrollViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let targetPoint = targetContentOffset as? CGPoint
        let currentPoint = scrollView.contentOffset

        if (targetPoint?.y ?? 0.0) > currentPoint.y {
            print("up")

        } else {
            print("down")
         }
    }
}

extension ViewController: collectionCellDelegate{
    func delete(cell: MyCollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: cell) {
            
            realm.beginWrite()
            realm.delete(closetItems.remove(at: indexPath.row))
            try! realm.commitWrite()
            
            filteredClosetItems.remove(at: indexPath.row)
            
            collectionView.reloadData()

        }
    }
}

extension ViewController: UISearchBarDelegate {
}




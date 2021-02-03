//
//  DetailViewController.swift
//  Wardrobe_Planner
//
//  Created by Paul Bunnell on 12/17/20.
//

import UIKit
import RealmSwift
import SCLAlertView

class DetailViewController: UIViewController {
    
    public var closetItem = ClosetItem()
    
    let realm = try! Realm()
    
    let pickerData = ["Shirt", "Pants", "Shoes"]
    
    var colorPicker = UIColorPickerViewController()

    @IBOutlet weak var detailBackground: UILabel!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var formalToggle: UISwitch!
    
//MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailBackground.layer.cornerRadius = 10
        detailBackground.clipsToBounds = true
      
        addItemButton.layer.cornerRadius = 10
        addItemButton.clipsToBounds = true
        
        colorPicker.delegate = self
        colorButton.layer.cornerRadius = 10
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }
    
// Deleting Closet Item
    
    func deleteData() {
        realm.beginWrite()
        realm.delete(realm.objects(ClosetItem.self))
        try! realm.commitWrite()
    }
    
// Saving Closet Item
    
    func saveData() {
        realm.beginWrite()
        realm.add(closetItem.self)
        try! realm.commitWrite()
    }
        
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        
        present(colorPicker, animated: true) {
            self.colorButton.backgroundColor = self.colorPicker.selectedColor
            self.closetItem.color = self.colorPicker.selectedColor
        }
        
        if colorPicker.isBeingDismissed {
            colorButton.backgroundColor = colorPicker.selectedColor
        }

    }
    
//MARK: Add Button
    
    @IBAction func addItemButtonTapped(_ sender: UIButton) {
        
        if formalToggle.isOn {
            closetItem.formal = true
        }
        else {
            closetItem.formal = false
        }
        
        let alertView = SCLAlertView()
        
        let alertViewResponder = SCLAlertViewResponder(alertview: alertView
        )
        
        alertView.showCustom("Name", subTitle: "Add a name that describes the item.", color: UIColor.init(red: 230/255.0, green: 29/255.0, blue: 99/255.0, alpha: 1), icon: UIImage(named: "Outfit")!)
        let nameText = alertView.addTextField()
        nameText.backgroundColor = UIColor.systemGray
        nameText.textColor = UIColor.secondarySystemBackground
        alertViewResponder.setDismissBlock {
            
            if let closetNameText = nameText.text {
                self.closetItem.name = closetNameText
            }
            
            self.saveData()

            self.performSegue(withIdentifier: "addItemUnwind", sender: nil)
        }
    
    }
        
}

//MARK: Color Picker

extension DetailViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        colorButton.backgroundColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorButton.backgroundColor = viewController.selectedColor
    }
}

extension DetailViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

}

extension DetailViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(red: 230/255.0, green: 29/255.0, blue: 99/255.0, alpha: 1), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        
    }
    
}

//
//  MyCollectionViewCell.swift
//  Wardrobe_Planner
//
//  Created by Paul Bunnell on 12/17/20.
//

import UIKit

protocol collectionCellDelegate: class {
    func delete(cell: MyCollectionViewCell)
}

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var deleteView: UIVisualEffectView!
    
    weak var delegate: collectionCellDelegate?
    
    static let identifier = "MyCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        deleteView.layer.cornerRadius = deleteView.bounds.width / 2
        deleteView.layer.masksToBounds = true
        deleteView.isHidden = !isEditing
    }
    
    var isEditing: Bool = false {
        didSet {
            deleteView.isHidden = !isEditing
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.delete(cell: self)
    }
    
    
    public func configure(with image: UIImage) {
        // might need to add string later
        cellImageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }

}



//
//  OutfitCollectionViewCell.swift
//  Wardrobe_Planner
//
//  Created by Paul Bunnell on 1/4/21.
//

import UIKit

protocol outfitCollectionCellDelegate: class {
    func delete(cell: OutfitCollectionViewCell)
}

class OutfitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shirtImageView: UIImageView!
    @IBOutlet weak var pantsImageView: UIImageView!
    @IBOutlet weak var shoesImageView: UIImageView!
    @IBOutlet weak var outfitCellLabel: UILabel!
    @IBOutlet weak var deleteView: UIVisualEffectView!
    
    weak var delegate: outfitCollectionCellDelegate?
    
    static let identifier = "OutfitCollectionViewCell"
    
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
    
    static func nib() -> UINib {
        return UINib(nibName: "OutfitCollectionViewCell", bundle: nil)
    }

}

//
//  SelectionTableViewCell.swift
//  Wardrobe_Planner
//
//  Created by Paul Bunnell on 12/18/20.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

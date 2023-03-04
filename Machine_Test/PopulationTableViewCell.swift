//
//  PopulationTableViewCell.swift
//  Machine_Test
//
//  Created by Mac on 04/03/23.
//

import UIKit

class PopulationTableViewCell: UITableViewCell {

    @IBOutlet weak var PopulationLabel: UILabel!
    @IBOutlet weak var YearLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

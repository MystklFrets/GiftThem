//
//  GIftTableViewCell.swift
//  GiftThem
//
//  Created by Raul Fernando Gutierrez on 2/26/17.
//  Copyright © 2017 Raul Fernando Gutierrez. All rights reserved.
//

import UIKit

class GIftTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

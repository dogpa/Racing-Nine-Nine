//
//  BillboardTableViewCell.swift
//  Racing Nine Nine
//
//  Created by Dogpa's MBAir M1 on 2021/11/30.
//

import UIKit

class BillboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankingLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

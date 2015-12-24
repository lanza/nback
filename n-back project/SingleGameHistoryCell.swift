//
//  SingleGameHistoryCell.swift
//  n-back project
//
//  Created by Nathan Lanza on 12/22/15.
//  Copyright © 2015 Nathan Lanza. All rights reserved.
//

import UIKit

class SingleGameHistoryCell: UITableViewCell {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backAndTurnsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

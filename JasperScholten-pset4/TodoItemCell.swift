 //
//  TodoItemCell.swift
//  JasperScholten-pset4
//
//  Created by Jasper Scholten on 20-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import UIKit

class TodoItemCell: UITableViewCell {

    @IBOutlet weak var listItem: UILabel!
    @IBOutlet weak var checkSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

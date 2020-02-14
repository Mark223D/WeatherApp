//
//  AddLocationTableViewCell.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/13/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import UIKit

class AddLocationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var model: City?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(_ model: City){
        self.titleLabel.text = model.name ?? ""
        self.subtitleLabel.text = model.country ?? ""
        print(model)
        self.model = City(id: model.id ?? 0, name:  model.name ?? "", country: model.country ?? "" )
        
    }
}

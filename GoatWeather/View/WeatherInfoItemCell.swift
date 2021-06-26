//
//  WeatherInfoItemCell.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/26/21.
//

import UIKit

class WeatherInfoItemCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var identifier: String {
        String(describing: WeatherInfoItemCell.self)
    }
    static var nib: UINib {
        UINib(nibName: String(describing: WeatherInfoItemCell.self), bundle: nil)
    }
    
}

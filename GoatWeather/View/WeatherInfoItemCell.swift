//
//  WeatherInfoItemCell.swift
//  GoatWeather
//
//  Created by Aldrich Wingsiong on 6/26/21.
//

import UIKit

class WeatherInfoItemCell: UITableViewCell {
    
    @IBOutlet var leftStackView: UIStackView!
    @IBOutlet var dayOfWeekLabel: UILabel!
    @IBOutlet var monthDayLabel: UILabel!
    
    @IBOutlet var weatherImageView: UIImageView!
    
    @IBOutlet var rightStackView: UIStackView!
    @IBOutlet var currentTempLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier: String = String(describing: WeatherInfoItemCell.self)

    static var nib: UINib {
        UINib(nibName: String(describing: WeatherInfoItemCell.self), bundle: nil)
    }
    
}

//
//  DetailTableViewCell.swift
//  DcardAPP
//
//  Created by 陳秉軒 on 2022/4/29.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

  
    
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

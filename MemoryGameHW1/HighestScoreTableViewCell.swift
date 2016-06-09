//
//  HighestScoreTableViewCell.swift
//  MemoryGameHW1
//
//  Created by Seiran on 21.05.16.
//  Copyright © 2016 SVTeam. All rights reserved.
//

import UIKit

//Taken from this tutorial:
//https:/developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson7.html

class HighestScoreTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var scoreLable: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
        
}

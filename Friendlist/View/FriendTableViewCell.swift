//
//  FriendTableViewCell.swift
//  Friendlist
//
//  Created by Low Wai Hong on 11/06/2019.
//  Copyright © 2019 Low Wai Hong. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    
    var viewModel: FriendCellViewModel?{
        didSet{
            bindViewModel()
        }
    }
    
    private func bindViewModel(){
        labelFullName?.text = viewModel?.fullName
        labelPhoneNumber?.text = viewModel?.phoneNumberText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MobileDataListCell.swift
//  SPHTechMobileAssignment
//
//  Created by Jingmeng.Gan on 8/9/19.
//  Copyright © 2019 Jingmeng.Gan. All rights reserved.
//

import UIKit

class MobileDataListCell: UITableViewCell {
    static let reuseIdentifier = String(describing: MobileDataListCell.self)
    static let height = CGFloat(250)
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var isDecreaseLabel: UILabel!
    
    private var viewModel: MobileDataListItemViewModel!
    
    func fill(with viewModel: MobileDataListItemViewModel) {
        self.viewModel = viewModel
        yearLabel.text = viewModel.year
        
        let strs = viewModel.records.map({ "\(String(describing: $0.quarter!))    \(String(describing: $0.volume_of_mobile_data!))" })
        infoLabel.text = strs.joined(separator: "\n")

        if viewModel.isDecrease {
           let decre_strs = viewModel.decreaseRecords.map({ "\(String(describing: $0.quarter!))" })
            isDecreaseLabel.text = decre_strs.joined(separator: "\n") + "📉🔻"
//            isDecreaseLabel.isHidden = false
        } else {
            isDecreaseLabel.text = "🔺📈"
//            isDecreaseLabel.isHidden = false
        }
        
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

//
//  ListCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田奈津代 on 2021/03/06.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var languageView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Public Methods
    func configure(_ item: Item) {
        titleLabel.text = item.fullName
        languageLabel.text = item.language
        languageView.isHidden = (item.language == "" )
    }
}

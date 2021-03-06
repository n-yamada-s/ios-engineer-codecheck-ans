//
//  RepositoryCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田奈津代 on 2021/03/06.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(_ item: Item) {
        titleLabel.text = item.fullName
        languageLabel.text = item.language
    }

}

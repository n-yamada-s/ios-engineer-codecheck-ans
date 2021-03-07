//
//  HistoryCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田奈津代 on 2021/03/07.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet private weak var wordLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: Public Methods
    func configure(_ word: String) {
        wordLabel.text = word
    }
}

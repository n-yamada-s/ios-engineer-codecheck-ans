//
//  LoadingCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田奈津代 on 2021/03/08.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet private weak var indicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    deinit {
        indicator.stopAnimating()
    }

    func start() {
        indicator.startAnimating()
    }
}

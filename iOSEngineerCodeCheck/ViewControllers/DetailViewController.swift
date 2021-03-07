//
//  DetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var issuesLabel: UILabel!

    // MARK: Public Properties
    var item: Item?

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        applyItem()
    }

    // MARK: Private Methods
    private func applyItem() {
        if let item = item {
            if let imgUrl = URL(string: item.owner.avatarUrl) {
                self.getImage(url: imgUrl)
            }
            self.navigationItem.title = item.fullName
            languageLabel.text = item.language
            starsLabel.text = "\(item.stargazersCount)"
            watchersLabel.text = "\(item.watchersCount)"
            forksLabel.text = "\(item.forksCount)"
            issuesLabel.text = "\(item.openIssuesCount)"
        }

    }

    private func getImage(url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data {
                let img = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.imageView.image = img
                }
            }
        }.resume()
    }
}

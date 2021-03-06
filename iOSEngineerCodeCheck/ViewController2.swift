//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var issuesLabel: UILabel!

    // MARK: Public Properties
    var vc1: ViewController!

    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = vc1.repo?.items[vc1.idx] {
            languageLabel.text = "Written in \(item.language)"
            starsLabel.text = "\(item.stargazersCount) stars"
            watchersLabel.text = "\(item.watchersCount) watchers"
            forksLabel.text = "\(item.forksCount) forks"
            issuesLabel.text = "\(item.openIssuesCount) open issues"
            getImage(item)
        }
    }

    // MARK: Private Methods
    private func getImage(_ item: Item) {
        titleLabel.text = item.fullName

        if let imgUrl = URL(string: item.owner.avatarUrl) {
            requestImage(url: imgUrl)
        }
    }

    private func requestImage(url: URL) {
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

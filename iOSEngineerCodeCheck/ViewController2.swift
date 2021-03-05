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

        let repo = vc1.repo[vc1.idx]

        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repo["watchers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
    }

    // MARK: Private Methods
    private func getImage() {
        let repo = vc1.repo[vc1.idx]

        titleLabel.text = repo["full_name"] as? String

        if let owner = repo["owner"] as? [String: Any] {
            let imgUrlStr = owner["avatar_url"] as? String ?? ""
            if let imgUrl = URL(string: imgUrlStr) {
                requestImage(url: imgUrl)
            }
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

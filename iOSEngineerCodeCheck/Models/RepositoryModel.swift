//
//  RepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田奈津代 on 2021/03/06.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol RepositoryModelDelegate: class {
    func repositoryDidChange(result: Repository)
}

class RepositoryModel {

    weak var delegate: RepositoryModelDelegate?

    func request(word: String, parPage: Int, page: Int = 1) {
        let urlStr = "https://api.github.com/search/repositories?q=\(word)&per_page=\(parPage)&page=\(page)"
        guard let url = URL(string: urlStr) else { return }

        requestRepo(url: url) { [weak self] repo in
            self?.delegate?.repositoryDidChange(result: repo)
        }
    }

    func requestRepo(url: URL, completionHandler: ((Repository) -> Void)?) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data {
                if let obj = try? JSONDecoder().decode(Repository.self, from: data) {
                    completionHandler?(obj)
                }
            }
        }
        task.resume()
    }
}

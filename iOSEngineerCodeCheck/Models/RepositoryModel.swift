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

    func request(word: String) {
        let urlStr = "https://api.github.com/search/repositories?q=" + word
        guard let url = URL(string: urlStr) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data {
                if let obj = try? JSONDecoder().decode(Repository.self, from: data) {
                    self?.delegate?.repositoryDidChange(result: obj)
                }
            }
        }
        task.resume()
    }

}

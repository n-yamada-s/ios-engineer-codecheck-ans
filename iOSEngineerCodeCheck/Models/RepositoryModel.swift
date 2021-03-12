//
//  RepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田奈津代 on 2021/03/06.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol RepositoryModelDelegate: class {
    func repositoryDidSuccess(result: Repository)
    func repositoryDidError()
}

class RepositoryModel {

    weak var delegate: RepositoryModelDelegate?

    func request(word: String, parPage: Int, page: Int = 1) {
        let urlStr = "https://api.github.com/search/repositories?q=\(word)&per_page=\(parPage)&page=\(page)"
        guard let url = URL(string: urlStr) else { return }

        requestRepo(url: url) { [weak self] repo in
            self?.delegate?.repositoryDidSuccess(result: repo)
        } errorHandler: { [weak self] in
            self?.delegate?.repositoryDidError()
        }
    }

    func requestRepo(url: URL, completion: ((Repository) -> Void)?, errorHandler: (() -> Void)?) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("client error: \(error.localizedDescription) \n")
                errorHandler?()
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                print("no data or no response")
                errorHandler?()
                return
            }

            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let obj = try? decoder.decode(Repository.self, from: data) {
                    completion?(obj)
                }
            } else {
                print("server error statusCode: \(response.statusCode)\n")
                errorHandler?()
            }
        }
        task.resume()
    }
}

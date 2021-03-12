//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田奈津代 on 2021/03/05.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Repository: Codable {
    let totalCount: Int
    let items: [Item]

    init() {
        totalCount = 0
        items = [Item]()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decode(Int?.self, forKey: .totalCount) ?? 0
        items = try container.decode(Array?.self, forKey: .items) ?? [Item]()
    }
}

struct Item: Codable {
    let fullName: String
    let language: String
    let owner: Owner
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try container.decode(String?.self, forKey: .fullName) ?? ""
        language = try container.decode(String?.self, forKey: .language) ?? ""
        owner = try container.decode(Owner?.self, forKey: .owner) ?? Owner()
        stargazersCount = try container.decode(Int?.self, forKey: .stargazersCount) ?? 0
        watchersCount = try container.decode(Int?.self, forKey: .watchersCount) ?? 0
        forksCount = try container.decode(Int?.self, forKey: .forksCount) ?? 0
        openIssuesCount = try container.decode(Int?.self, forKey: .openIssuesCount) ?? 0
    }
}

struct Owner: Codable {
    let avatarUrl: String

    init() {
        avatarUrl = ""
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatarUrl = try container.decode(String?.self, forKey: .avatarUrl) ?? ""
    }
}

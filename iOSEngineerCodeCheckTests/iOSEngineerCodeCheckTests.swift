//
//  IOSEngineerCodeCheckTests.swift
//  IOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class IOSEngineerCodeCheckTests: XCTestCase {

    var historyVC: HistoryViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let exp = expectation(description: "RequestRepository")
        exp.expectedFulfillmentCount = 2

        let word = "swift"
        let urlStr = "https://api.github.com/search/repositories?q=" + word
        guard let url = URL(string: urlStr) else { return }
        RepositoryModel().requestRepo(url: url, completionHandler: { _ in
            exp.fulfill()
            exp.fulfill()
        })
        wait(for: [exp], timeout: 3.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let word = "swift"
            for _ in 0..<3 {
                RepositoryModel().request(word: word)
            }
        }
    }

}

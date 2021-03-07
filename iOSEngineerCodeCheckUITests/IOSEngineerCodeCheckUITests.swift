//
//  IOSEngineerCodeCheckUITests.swift
//  IOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class IOSEngineerCodeCheckUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        // キーボード入力「Swift」で検索
        let listSearchbutton = app.buttons["listSearchbutton"]
        listSearchbutton.tap()
        // キーボードが日本語表示だった場合
//        app.buttons["Next keyboard"].tap()
        app.keys["S"].tap()
        app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["f"]/*[[".keyboards.keys[\"f\"]",".keys[\"f\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(3)

        // キーボード入力「Test」で検索
        app.otherElements["listSearchbar"].buttons["Clear text"].tap()
        listSearchbutton.tap()
        app.keys["T"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(3)

        // 詳細画面に遷移1
        app.tables["listTableView"]/*@START_MENU_TOKEN@*/.staticTexts["pytest-dev/pytest"]/*[[".cells.staticTexts[\"pytest-dev\/pytest\"]",".staticTexts[\"pytest-dev\/pytest\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(1)
        app.navigationBars["pytest-dev/pytest"].buttons["GitHubのリポジトリ"].tap()
        sleep(1)

        // 詳細画面に遷移2
        app.tables["listTableView"].staticTexts["facebook/jest"].tap()
        sleep(1)
        app.navigationBars["facebook/jest"].buttons["GitHubのリポジトリ"].tap()
        sleep(1)

        // 検索履歴の「Swift」で検索
        listSearchbutton.tap()
        app.otherElements["historySearchbar"].buttons["Clear text"].tap()
        app.tables["historyTableView"].children(matching: .cell).element(boundBy: 1).staticTexts["Swift"].tap()
        sleep(3)

        app.tables["listTableView"]/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"apple/swift").element/*[[".cells.containing(.staticText, identifier:\"C++\").element",".cells.containing(.staticText, identifier:\"apple\/swift\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["apple/swift"].buttons["GitHubのリポジトリ"].tap()
        sleep(1)

        // 検索履歴のクリア
        listSearchbutton.tap()
        app.navigationBars["検索履歴"].buttons["clearButton"].tap()
        sleep(3)
    }


    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

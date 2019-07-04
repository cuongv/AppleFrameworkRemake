//
//  AppleFrameworkRemakeTests.swift
//  AppleFrameworkRemakeTests
//
//  Created by Cuong Vuong on 12/6/19.
//  Copyright © 2019 i3. All rights reserved.
//

import XCTest
@testable import AppleFrameworkRemake

class AppleFrameworkRemakeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCVNotificationCenter() {
        let notification = Notification(name: .init("notification"), object: self, userInfo: ["data": 1])
        CVNotificationCenter.default.addObserver(self, selector: #selector(gotNotification), name: .init("notification"))
        CVNotificationCenter.default.post(notification)
//        CVNotificationCenter.default.removeObserver(self)
//        CVNotificationCenter.default.post(notification)
        
        self.expectation(forNotification: .init("notification"), object: self) { notification in
            let userInfo = notification.userInfo as! [String: Int]
            XCTAssertTrue(userInfo["data"]! == 1, "Must equal to One")
            return true
        }
    }
    
    @objc private func gotNotification(noti: Notification) {
        print("Get notification")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

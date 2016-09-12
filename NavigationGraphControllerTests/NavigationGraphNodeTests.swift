//
//  NavigationGraphNodeTests.swift
//  GraphNavigationController
//
//  Created by Erick Andrade on 9/12/16.
//  Copyright © 2016 pman215. All rights reserved.
//

import XCTest
@testable import NavigationGraphController


class NavigationGraphNodeTests: XCTestCase {

  func testInit() {
        let node = NavigationGraphNode(value: UIViewController(),
                                       rootNode: false)
        XCTAssertNotNil(node)
    }

    func testConvenienceInit() {
        let node = NavigationGraphNode(value: UIViewController())
        XCTAssertNotNil(node)
    }

    func testEqualNodes() {
        let controller = UIViewController()
        let leftNode = NavigationGraphNode(value: controller)
        let rightNode = NavigationGraphNode(value: controller)
        XCTAssertEqual(leftNode, rightNode)
    }

    func testNotEqualNodes() {
        let leftNode = NavigationGraphNode(value: UIViewController())
        let rightNode = NavigationGraphNode(value: UIViewController())
        XCTAssertNotEqual(leftNode, rightNode)
    }
}

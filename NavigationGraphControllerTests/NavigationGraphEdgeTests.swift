//
//  NavigationGraphEdgeTests.swift
//  GraphNavigationController
//
//  Created by Erick Andrade on 9/12/16.
//  Copyright © 2016 pman215. All rights reserved.
//

import XCTest
@testable import NavigationGraphController

class NavigationGraphEdgeTests: XCTestCase {

    let nodeA = NavigationGraphNode(value: UIViewController())
    let nodeB = NavigationGraphNode(value: UIViewController())
    let nodeC = NavigationGraphNode(value: UIViewController())

    let AtoB = UIButton()
    let AtoC = UIButton()
    let CtoB = UIButton()

    func testInit() {
        let edge = NavigationGraphEdge(source: nodeA, action: AtoB, target: nodeB)
        XCTAssertNotNil(edge)
    }

    func testEqualEdges() {
        let edgeA = NavigationGraphEdge(source: nodeA, action: AtoB, target: nodeB)
        let edgeB = NavigationGraphEdge(source: nodeA, action: AtoB, target: nodeB)
        XCTAssertEqual(edgeA, edgeB)
    }

    func testEdgesWithDifferentNodes() {
        let edgeA = NavigationGraphEdge(source: nodeA, action: AtoB, target: nodeB)
        let edgeB = NavigationGraphEdge(source: nodeA, action: AtoC, target: nodeC)
        let edgeC = NavigationGraphEdge(source: nodeC, action: CtoB, target: nodeB)

        XCTAssertNotEqual(edgeA, edgeB)
        XCTAssertNotEqual(edgeA, edgeC)
        XCTAssertNotEqual(edgeB, edgeC)
    }

    func testEdgesWithSameNodesButDifferentActions() {
        let actionA = UIButton()
        let actionB = UIButton()

        let sourceNode = NavigationGraphNode(value: UIViewController())
        let targetNode = NavigationGraphNode(value: UIViewController())

        let edgeA = NavigationGraphEdge(source: sourceNode, action: actionA, target: targetNode)
        let edgeB = NavigationGraphEdge(source: sourceNode, action: actionB, target: targetNode)

        XCTAssertNotEqual(edgeA, edgeB)
    }
}

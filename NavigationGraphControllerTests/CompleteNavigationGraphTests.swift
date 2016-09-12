//
//  CompleteNavigationGraphTests.swift
//  GraphNavigationController
//
//  Created by Erick Andrade on 9/12/16.
//  Copyright © 2016 pman215. All rights reserved.
//

import XCTest
@testable import NavigationGraphController

class CompleteNavigationGraphTests: XCTestCase {

    func testCompleteGraph() {

        // All nodes are conneted to every other node
        //      __________________________
        //     |  _____________________   |
        //     v |                     v  |
        //    -----       -----       -----
        //    |   | ----> |   | ----> |   |
        //    | A |       | B |       | C |
        //    |   | <---- |   | <---- |   |
        //    -----       -----       -----

        let nodeA = NavigationGraphNode(value: UIViewController(),
                                        rootNode: true)
        let nodeB = NavigationGraphNode(value: UIViewController())
        let nodeC = NavigationGraphNode(value: UIViewController())

        let AtoB = UIButton()
        let AtoC = UIButton()
        let BtoA = UIButton()
        let BtoC = UIButton()
        let CtoA = UIButton()
        let CtoB = UIButton()

        let nodeAToNodeB = NavigationGraphEdge(source: nodeA, action: AtoB, target: nodeB)
        let nodeAToNodeC = NavigationGraphEdge(source: nodeA, action: AtoC, target: nodeC)
        let nodeBToNodeA = NavigationGraphEdge(source: nodeB, action: BtoA, target: nodeA)
        let nodeBToNodeC = NavigationGraphEdge(source: nodeB, action: BtoC, target: nodeC)
        let nodeCToNodeA = NavigationGraphEdge(source: nodeC, action: CtoA, target: nodeA)
        let nodeCToNodeB = NavigationGraphEdge(source: nodeC, action: CtoB, target: nodeB)


        let nodes: Set<NavigationGraphNode> = Set(arrayLiteral: nodeA, nodeB, nodeC)
        let edges: Set<NavigationGraphEdge> = Set(arrayLiteral: nodeAToNodeB, nodeAToNodeC,
                                                                nodeBToNodeA, nodeBToNodeC,
                                                                nodeCToNodeA, nodeCToNodeB)

        let completeGraph: CompleteNavigationGraph
        do {
            completeGraph = try CompleteNavigationGraph(nodes: nodes, edges: edges)
            XCTAssertNotNil(completeGraph)
        } catch {
            XCTFail("No error should be thrown because graph is valid")
        }
    }

    func testMissingReverseEdge() {

        // Node C is not connected with Node A
        //        _____________________
        //       |                     v
        //    -----       -----       -----
        //    |   | ----> |   | ----> |   |
        //    | A |       | B |       | C |
        //    |   | <---- |   | <---- |   |
        //    -----       -----       -----

        let nodeA = NavigationGraphNode(value: UIViewController(),
                                        rootNode: true)
        let nodeB = NavigationGraphNode(value: UIViewController())
        let nodeC = NavigationGraphNode(value: UIViewController())

        let AtoB = UIButton()
        let AtoC = UIButton()
        let BtoA = UIButton()
        let BtoC = UIButton()
        let CtoB = UIButton()

        let nodeAToNodeB = NavigationGraphEdge(source: nodeA, action: AtoB, target: nodeB)
        let nodeAToNodeC = NavigationGraphEdge(source: nodeA, action: AtoC, target: nodeC)
        let nodeBToNodeA = NavigationGraphEdge(source: nodeB, action: BtoA, target: nodeA)
        let nodeBToNodeC = NavigationGraphEdge(source: nodeB, action: BtoC, target: nodeC)
        let nodeCToNodeB = NavigationGraphEdge(source: nodeC, action: CtoB, target: nodeB)


        let nodes: Set<NavigationGraphNode> = Set(arrayLiteral: nodeA, nodeB, nodeC)
        let edges: Set<NavigationGraphEdge> = Set(arrayLiteral: nodeAToNodeB, nodeAToNodeC,
                                                                nodeBToNodeA, nodeBToNodeC,
                                                                nodeCToNodeB)

        do {
            let _ = try CompleteNavigationGraph(nodes: nodes, edges: edges)
            XCTFail("This line should not execute")
        } catch CompleteNavigationGraphError.GraphNodeNotFullyConnected(node: let node) {
            XCTAssertEqual(node, nodeC)
        }catch CompleteNavigationGraphError.GraphNodeMissingReverseEdge(node: let node) {
            XCTAssertEqual(node, nodeA)
        } catch {
            XCTFail("Error should've been handled")
        }
    }

    func testNotCompleteGraph() {

        // Node A and Node C are not connected
        //    -----       -----       -----
        //    |   | ----> |   | ----> |   |
        //    | A |       | B |       | C |
        //    |   | <---- |   | <---- |   |
        //    -----       -----       -----

        let nodeA = NavigationGraphNode(value: UIViewController(),
                                        rootNode: true)
        let nodeB = NavigationGraphNode(value: UIViewController())
        let nodeC = NavigationGraphNode(value: UIViewController())

        let AtoB = UIButton()
        let BtoA = UIButton()
        let BtoC = UIButton()
        let CtoB = UIButton()

        let nodeAToNodeB = NavigationGraphEdge(source: nodeA, action: AtoB, target: nodeB)
        let nodeBToNodeA = NavigationGraphEdge(source: nodeB, action: BtoA, target: nodeA)
        let nodeBToNodeC = NavigationGraphEdge(source: nodeB, action: BtoC, target: nodeC)
        let nodeCToNodeB = NavigationGraphEdge(source: nodeC, action: CtoB, target: nodeB)


        let nodes: Set<NavigationGraphNode> = Set(arrayLiteral: nodeA, nodeB, nodeC)
        let edges: Set<NavigationGraphEdge> = Set(arrayLiteral: nodeAToNodeB,
                                                                nodeBToNodeA, nodeBToNodeC,
                                                                nodeCToNodeB)

        do {
            let _ = try CompleteNavigationGraph(nodes: nodes, edges: edges)
            XCTFail("This line should not execute")
        } catch CompleteNavigationGraphError.GraphNodeNotFullyConnected(node: let node) {
            XCTAssertTrue([nodeA, nodeC].contains(node))
        } catch {
            XCTFail("Error should've been handled")
        }
    }

    func testNodeConnectsToUnknownNode() {

        // Node C is not part of the graph
        //    -----       -----       -----
        //    |   | ----> |   | ----> |   |
        //    | A |       | B |       | C?|
        //    |   | <---- |   | <---- |   |
        //    -----       -----       -----

        let nodeA = NavigationGraphNode(value: UIViewController(),
                                        rootNode: true)
        let nodeB = NavigationGraphNode(value: UIViewController())
        let nodeC = NavigationGraphNode(value: UIViewController())

        let AtoB = UIButton()
        let BtoA = UIButton()
        let BtoC = UIButton()
        let CtoB = UIButton()

        let nodeAToNodeB = NavigationGraphEdge(source: nodeA, action: AtoB, target: nodeB)
        let nodeBToNodeA = NavigationGraphEdge(source: nodeB, action: BtoA, target: nodeA)
        let nodeBToNodeC = NavigationGraphEdge(source: nodeB, action: BtoC, target: nodeC)
        let nodeCToNodeB = NavigationGraphEdge(source: nodeC, action: CtoB, target: nodeB)

        // Notice how Node C is not part of the nodes set
        let nodes: Set<NavigationGraphNode> = Set(arrayLiteral: nodeA, nodeB)
        let edges: Set<NavigationGraphEdge> = Set(arrayLiteral: nodeAToNodeB,
                                                                nodeBToNodeA, nodeBToNodeC,
                                                                nodeCToNodeB)

        do {
            let _ = try CompleteNavigationGraph(nodes: nodes, edges: edges)
            XCTFail("This line should not execute")
        } catch CompleteNavigationGraphError.GraphEdgeWithUnknowTragetNode(edge: let edge){
            XCTAssertEqual(edge, nodeBToNodeC)
        } catch {
            XCTFail("Error should've been handled")
        }
    }

    func testGraphWithNoRootNode() {
        let nodeA = NavigationGraphNode(value: UIViewController(),
                                        rootNode: false)
        let nodes: Set<NavigationGraphNode> = Set(arrayLiteral: nodeA)
        let edges = Set<NavigationGraphEdge>()

        do {
            let _ = try CompleteNavigationGraph(nodes: nodes, edges: edges)
            XCTFail("This line should not execute")
        } catch CompleteNavigationGraphError.GraphWithNoRootNode {
            // Do nothing
        } catch {
            XCTFail("Error should've been handled")
        }
    }

    func testGraphWithMoreThanOneRootNode() {
        let nodeA = NavigationGraphNode(value: UIViewController(),
                                        rootNode: true)
        let nodeB = NavigationGraphNode(value: UIViewController(),
                                        rootNode: true)
        let nodes: Set<NavigationGraphNode> = Set(arrayLiteral: nodeA, nodeB)
        let edges = Set<NavigationGraphEdge>()

        do {
            let _ = try CompleteNavigationGraph(nodes: nodes, edges: edges)
            XCTFail("This line should not execute")
        } catch CompleteNavigationGraphError.GraphWithMoreThanOneRootNode {
            // Do nothing
        } catch {
            XCTFail("Error should've been handled")
        }
    }

    func testTargetForAction() {

        //    -----       -----
        //    |   | ----> |   |
        //    | A |       | B |
        //    |   | <---- |   |
        //    -----       -----

        let nodeA = NavigationGraphNode(value: UIViewController(),
                                        rootNode: true)
        let nodeB = NavigationGraphNode(value: UIViewController())

        let AtoB = UIButton()
        let BtoA = UIButton()

        let nodeAToNodeB = NavigationGraphEdge(source: nodeA, action: AtoB, target: nodeB)
        let nodeBToNodeA = NavigationGraphEdge(source: nodeB, action: BtoA, target: nodeA)


        let nodes: Set<NavigationGraphNode> = Set(arrayLiteral: nodeA, nodeB )
        let edges: Set<NavigationGraphEdge> = Set(arrayLiteral: nodeAToNodeB, nodeBToNodeA)

        let completeGraph = try! CompleteNavigationGraph(nodes: nodes, edges: edges)

        let nodeBTarget = completeGraph.targetNode(for: AtoB)
        XCTAssertEqual(nodeBTarget, nodeB)

        let nodeATarget = completeGraph.targetNode(for: BtoA)
        XCTAssertEqual(nodeATarget, nodeA)

        let unknownTarget = completeGraph.targetNode(for: UIControl())
        XCTAssertNil(unknownTarget)
    }
}

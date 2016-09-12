//
//  CompleteNavigationGraph.swift
//  GraphNavigationController
//
//  Created by Erick Andrade on 9/12/16.
//  Copyright © 2016 pman215. All rights reserved.
//

import UIKit

enum CompleteNavigationGraphError: ErrorType {
    case GraphWithMoreThanOneRootNode
    case GraphWithNoRootNode
    case GraphEdgeSameSourceAndTargetNode(edge: NavigationGraphEdge)
    case GraphEdgeWithUnknowTragetNode(edge: NavigationGraphEdge)
    case GraphNodeMissingReverseEdge(node: NavigationGraphNode)
    case GraphNodeNotFullyConnected(node: NavigationGraphNode)
}

struct CompleteNavigationGraph {

    let nodes: Set<NavigationGraphNode>
    let edges: Set<NavigationGraphEdge>
    lazy var rootNode: NavigationGraphNode = {
        return self.nodes.filter { $0.rootNode }.first!
    }()

    init(nodes: Set<NavigationGraphNode>, edges: Set<NavigationGraphEdge>) throws {
        self.nodes = nodes
        self.edges = edges
        try validate(graph: self)
    }

    func targetNode(for action: UIControl) -> NavigationGraphNode? {
        return edges.filter { $0.action === action }.first?.target
    }
}

private extension CompleteNavigationGraph {

    func validate(graph graph: CompleteNavigationGraph) throws {
        try validateRootNode(nodes: graph.nodes)
        try validate(nodes: graph.nodes, in: graph)
    }

    func validateRootNode(nodes nodes: Set<NavigationGraphNode>) throws {
        let rootNodeCount = nodes.filter { $0.rootNode }.count

        switch rootNodeCount {
        case _ where rootNodeCount > 1:
            throw CompleteNavigationGraphError.GraphWithMoreThanOneRootNode
        case _ where rootNodeCount <= 0:
            throw CompleteNavigationGraphError.GraphWithNoRootNode
        default:
            break
        }
    }

    func validate(nodes nodes: Set<NavigationGraphNode>,
                        in graph: CompleteNavigationGraph) throws {
        var tracker = newEdgeVisitTracker(with: graph.edges)
        for node in graph.nodes {
            tracker = try validate(node: node, in: graph, using: tracker)
        }
    }

    typealias EdgeVisitTracker = [NavigationGraphEdge : Bool]
    
    func newEdgeVisitTracker(with edges: Set<NavigationGraphEdge>) -> EdgeVisitTracker {
        var tracker = [NavigationGraphEdge : Bool]()
        var edgesGenerator = edges.generate()
        while let edge = edgesGenerator.next() {
            tracker[edge] = false
        }
        return tracker
    }

    func new(edgeVisitTracker tracker: EdgeVisitTracker,
             visiting egdes: [NavigationGraphEdge]) -> EdgeVisitTracker {
        var tracker = tracker
        for edge in edges {
            tracker[edge] = true
        }
        return tracker
    }
    
    func validate(node node: NavigationGraphNode,
                 in graph: CompleteNavigationGraph,
                 using tracker: EdgeVisitTracker) throws -> EdgeVisitTracker {
        try validate(node: node, connectsWithAllNodesIn: graph)
        return try validate(node: node,
                            isCompletelyConnectedIn: graph,
                            using: tracker)
    }

    func validate(node node: NavigationGraphNode,
                  connectsWithAllNodesIn graph: CompleteNavigationGraph) throws {
        var nodeComplement = complement(of: node, in: graph)

        var nodeEdges = graph.edges.filter { $0.source == node }.generate()
        while let edge = nodeEdges.next() {
            let targetNodeIsNotInGraph = (nodeComplement.remove(edge.target) == nil)
            if targetNodeIsNotInGraph {
                throw CompleteNavigationGraphError.GraphEdgeWithUnknowTragetNode(edge: edge)
            }
        }

        if !nodeComplement.isEmpty {
            throw CompleteNavigationGraphError.GraphNodeNotFullyConnected(node: node)
        }
    }

    func complement(of node: NavigationGraphNode,
                    in graph: CompleteNavigationGraph) -> Set<NavigationGraphNode> {
        var complement = graph.nodes
        complement.remove(node)
        return complement
    }

    func validate(node node: NavigationGraphNode,
                  isCompletelyConnectedIn graph: CompleteNavigationGraph,
                  using tracker: EdgeVisitTracker) throws -> EdgeVisitTracker {
        let unvisitedNodeEdges = unvisitedEdges(for: node, in: graph, edgeVisitTracker: tracker)
        let reverseUnvisitedNodeEdges = try reverse(nodeEdges: unvisitedNodeEdges, edges: graph.edges)

        let newlyVisitedEdges = unvisitedNodeEdges + reverseUnvisitedNodeEdges
        let updatedEdgeVisitTracker = new(edgeVisitTracker: tracker,
                                          visiting: newlyVisitedEdges)
        return updatedEdgeVisitTracker
    }
    
   func unvisitedEdges(for node: NavigationGraphNode,
                       in graph: CompleteNavigationGraph,
                       edgeVisitTracker: EdgeVisitTracker) -> [NavigationGraphEdge] {
        let nodeEdges = graph.edges.filter { $0.source == node }
        let visitedNodeEdges = nodeEdges.filter { edgeVisitTracker[$0] == false }
        return visitedNodeEdges
    }

    func reverse(nodeEdges nodeEdges: [NavigationGraphEdge],
                 edges: Set<NavigationGraphEdge>) throws -> [NavigationGraphEdge] {
        var reverseEdges = [NavigationGraphEdge]()
        for edge in nodeEdges {
            let reverseEdge = try reverse(edge: edge, edges: edges)
            reverseEdges.append(reverseEdge)
        }
        return reverseEdges
    }

    func reverse(edge edge: NavigationGraphEdge,
                 edges: Set<NavigationGraphEdge>) throws -> NavigationGraphEdge {
        let sourceNode = edge.source
        let targetNode = edge.target

        if sourceNode == targetNode {
            throw CompleteNavigationGraphError.GraphEdgeSameSourceAndTargetNode(edge: edge)
        }
        let targetNodeEdges = edges.filter { $0.source == targetNode }
        let edge = targetNodeEdges.filter { $0.target == sourceNode }

        guard let reverseEdge = edge.first else {
            throw CompleteNavigationGraphError.GraphNodeMissingReverseEdge(node: sourceNode)
        }
        return reverseEdge
    }
}

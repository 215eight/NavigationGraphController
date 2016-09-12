//
//  NavigationGraphEdge.swift
//  GraphNavigationController
//
//  Created by Erick Andrade on 9/12/16.
//  Copyright © 2016 pman215. All rights reserved.
//

import UIKit

struct NavigationGraphEdge {
    let source: NavigationGraphNode
    let action: UIControl
    let target: NavigationGraphNode

    init(source: NavigationGraphNode,
         action: UIControl,
         target: NavigationGraphNode) {
        self.source = source
        self.action = action
        self.target = target
    }
}

extension NavigationGraphEdge: Hashable {
    var hashValue: Int {
        return action.hashValue
    }
}

extension NavigationGraphEdge: Equatable { }

func ==(lhs: NavigationGraphEdge, rhs: NavigationGraphEdge) -> Bool {
    return lhs.source.value == rhs.source.value &&
        lhs.action == rhs.action &&
        lhs.target.value == rhs.target.value
}
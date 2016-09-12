//
//  NavigationGraphNode.swift
//  GraphNavigationController
//
//  Created by Erick Andrade on 9/12/16.
//  Copyright © 2016 pman215. All rights reserved.
//

import UIKit

struct NavigationGraphNode {
    let value: UIViewController
    let rootNode: Bool

    init(value: UIViewController,
         rootNode: Bool = false) {
        self.value = value
        self.rootNode = rootNode
    }
}

extension NavigationGraphNode: Hashable {
    var hashValue: Int {
        return value.hashValue
    }
}

extension NavigationGraphNode: Equatable { }

func ==(lhs: NavigationGraphNode, rhs: NavigationGraphNode) -> Bool {
    return lhs.value == rhs.value
}

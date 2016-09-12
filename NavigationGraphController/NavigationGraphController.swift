//
//  NavigationGraphController.swift
//  GraphNavigationController
//
//  Created by Erick Andrade on 9/12/16.
//  Copyright © 2016 pman215. All rights reserved.
//

import UIKit

class NavigationGraphController: UIViewController {

    private var graph: CompleteNavigationGraph
    private(set) var selectedConroller: UIViewController {
        didSet (oldController) {
            if oldController != selectedConroller {
                swapController(oldController: oldController,
                               newController: selectedConroller)
            }
        }
    }

    init(graph: CompleteNavigationGraph) {
        self.graph = graph
        selectedConroller = self.graph.rootNode.value

        super.init(nibName: nil, bundle: nil)

        register(graph)
        swapController(oldController: nil, newController: selectedConroller)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showController(for action: UIControl) {
        if let target = graph.targetNode(for: action) {
            selectedConroller = target.value
        }
    }
}

private extension NavigationGraphController {

    func register(graph: CompleteNavigationGraph) {
        for edge in graph.edges {
            edge.action.addTarget(self,
                                  action: #selector(showController(for:)),
                                  forControlEvents: UIControlEvents.TouchUpInside)
        }
    }

    func swapController(oldController oldController: UIViewController?,
                        newController: UIViewController) {

        if let oldController = oldController {
            oldController.willMoveToParentViewController(nil)
            oldController.view.removeFromSuperview()
            oldController.removeFromParentViewController()
        }

        addChildViewController(newController)
        newController.view.frame = view.frame
        view.addSubview(newController.view)
        newController.didMoveToParentViewController(self)
    }
}

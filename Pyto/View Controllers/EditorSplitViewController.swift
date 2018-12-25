//
//  SplitViewController.swift
//  Pyto
//
//  Created by Adrian Labbe on 12/21/18.
//  Copyright © 2018 Adrian Labbé. All rights reserved.
//

import UIKit
import SplitKit

/// A Split view controller for displaying the editor and the console.
class EditorSplitViewController: SplitViewController {
    
    /// The View controller for editing code.
    var editor: EditorViewController!
    
    /// The console.
    var console: PyContentViewController!
    
    /// A down arrow image for dismissing keyboard.
    static var downArrow: UIImage {
        return UIGraphicsImageRenderer(size: .init(width: 24, height: 24)).image(actions: { context in
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 1, y: 7))
            path.addLine(to: CGPoint(x: 11, y: 17))
            path.addLine(to: CGPoint(x: 22, y: 7))
            
            UIColor.white.setStroke()
            path.lineWidth = 2
            path.stroke()
            
            context.cgContext.addPath(path.cgPath)
            
        }).withRenderingMode(.alwaysOriginal)
    }
    
    /// The shared View controller.
    static let shared = EditorSplitViewController()
    
    // MARK: - Split view controller
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        willTransition(to: traitCollection, with: ViewControllerTransitionCoordinator())
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let firstChild = self.firstChild, let secondChild = self.secondChild else {
            return
        }
        
        firstChild.viewWillTransition(to: firstChild.view.frame.size, with: ViewControllerTransitionCoordinator())
        secondChild.viewWillTransition(to: firstChild.view.frame.size, with: ViewControllerTransitionCoordinator())
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if newCollection.horizontalSizeClass == .compact {
            firstChild?.view.removeFromSuperview()
            firstChild?.removeFromParent()
            secondChild?.view.removeFromSuperview()
            secondChild?.removeFromParent()
            firstChild = nil
            secondChild = nil
            
            for view in view.subviews {
                view.removeFromSuperview()
            }
            
            addChild(editor)
            editor.view.frame = view.frame
            editor.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(editor.view)
            
            if Python.shared.isScriptRunning {
                let navVC = UINavigationController(rootViewController: console)
                navVC.view.tintColor = UIColor(named: "TintColor")
                present(navVC, animated: true, completion: nil)
            }
        } else {
            
            for view in view.subviews {
                view.removeFromSuperview()
            }
            
            viewDidLoad()
            arrangement = .horizontal
            super.viewDidAppear(false)
            
            firstChild = editor
            secondChild = console
        }
    }
}
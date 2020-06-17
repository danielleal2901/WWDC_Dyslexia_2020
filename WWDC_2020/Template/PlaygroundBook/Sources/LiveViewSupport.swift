//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import SpriteKit
import PlaygroundSupport


/// Instantiates a new instance of a live view.
///
/// By default, this loads an instance of `LiveViewController` from `LiveView.storyboard`.
public func instantiateFirstLiveView() -> PlaygroundLiveViewable {

    let view = SKView(frame: CGRect(x: 0, y: 0, width: 1024 , height: 1366))
    let sceneSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
    let scene = LoadingScene(size: sceneSize)
    view.presentScene(scene)
//    view.showsFPS = true
//    view.showsNodeCount = true
    return view
}

public func instantiateSecondLiveView() -> PlaygroundLiveViewable {
    
    let view = SKView(frame: CGRect(x: 0, y: 0, width: 1024 , height: 1366))
    let sceneSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
    let scene = LoadingSecondScene(size: sceneSize)
    view.presentScene(scene)
//    view.showsFPS = true
//    view.showsNodeCount = true

    return view
}



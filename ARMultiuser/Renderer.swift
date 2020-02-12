//
//  Renderer.swift
//  ARMultiuser
//
//  Created by NMI Capstone on 10/22/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity
import Foundation
import SpriteKit
import CoreMotion
import CoreGraphics

extension ViewController
{
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor)
    {
        if let name = anchor.name, name.hasPrefix("max")
        {
            node.addChildNode(loadRedPandaModel())
        }
        
        if let name = anchor.name, name.hasPrefix("oven")
        {
            node.addChildNode(loadOvenModel())
        }
        
        if let name = anchor.name, name.hasPrefix("workstation")
        {
            node.addChildNode(loadWSModel())
        }
        
        if let name = anchor.name, name.hasPrefix("wrks")
        {
            node.addChildNode((loadWSSModel()))
        }
        
        if let name = anchor.name, name.hasPrefix("wrksc")
        {
            node.addChildNode((loadWSSCModel()))
        }
        
        if let name = anchor.name, name.hasPrefix("shelf")
        {
            node.addChildNode(loadShelfModel())
        }
        
        if let name = anchor.name, name.hasPrefix("window")
        {
            node.addChildNode(loadWinModel())
           // var noder = loadS0()
            //node.addChildNode(noder)
        }
        
        if let name = anchor.name, name.hasPrefix("dough")
        {
            sceneView.pointOfView?.addChildNode(loadDoughModel())
        }
        
        if let name = anchor.name, name.hasPrefix("tomato")
        {
            sceneView.pointOfView?.addChildNode(loadCheeseModel())
        }
        
        if let name = anchor.name, name.hasPrefix("handAnchor")
        {
            node.addChildNode(lastNode)
            
        }
        
        if let name = anchor.name, name.hasPrefix("s0")
        {
            var node1 = loadS0()
            node.addChildNode(node1)
        
            
        }
        
        if let name = anchor.name, name.hasPrefix("s50")
        {
            node.addChildNode(loadS50())
            
            
        }
        
        if let name = anchor.name, name.hasPrefix("s100")
        {
            node.addChildNode(loadS100())
            
            
        }
    }
    
    
    
}

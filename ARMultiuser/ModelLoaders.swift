//
//  ModelLoaders.swift
//  ARMultiuser
//
//  Created by NMI Capstone on 11/13/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity
import Foundation
import SpriteKit
import CoreMotion
import CoreGraphics


extension ViewController{
    
    // MARK: - AR session management
    func loadRedPandaModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "max", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        return referenceNode
    }
    
    func loadOvenModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "model", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let oveNode = SCNReferenceNode(url: sceneURL)!
        //oveNode.eulerAngles.y = (sceneView.session.currentFrame?.camera.eulerAngles.y)!
        oveNode.scale = SCNVector3Make(0.015, 0.015, 0.015)
        oveNode.load()
        
        
        return oveNode
    }
    
    func loadDoughModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "dough", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadCheeseModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "cheese", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadCheeseShredModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "bowl", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadTomatoModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "tomato", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadTomatoSlicedModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "tomatoSliced", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadWSModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "workstation2", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        //referenceNode.eulerAngles.y = (sceneView.session.currentFrame?.camera.eulerAngles.y)!
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadWSSModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "workstation2S", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadWSSCModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "workstation2SC", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadWinModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "window", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.eulerAngles.y = ((sceneView.session.currentFrame?.camera.eulerAngles.y)! - 0.55)
        
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadShelfModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "shelf", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.eulerAngles.y = ((sceneView.session.currentFrame?.camera.eulerAngles.y)! - 1.3)
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadSauceModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "sauce", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.position = SCNVector3Make(0.0, 0.1, 0.0)
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadMozzModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "mozz", withExtension: "scn", subdirectory: "Assets.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.position = SCNVector3Make(0.0, 0.15, 0.0)
        
        referenceNode.load()
        
        
        return referenceNode
    }
    
    func loadS0() -> SCNNode {
        
        let text = SCNText(string: "Score: 0", extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 4.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.white
        text.alignmentMode = CATextLayerAlignmentMode.center.rawValue

        
        let textNode = SCNNode(geometry: text)
        
        let fontSize = Float(0.04)
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
        textNode.position.y = 0.6
        textNode.position.x = -0.4
        textNode.eulerAngles.y = ((sceneView.session.currentFrame?.camera.eulerAngles.y)!)
        textNode.name = "S0"
       

        return textNode
    }
    
    func loadS50() -> SCNNode {
    
    let text = SCNText(string: "Score: 50", extrusionDepth: 0.1)
    text.font = UIFont.systemFont(ofSize: 4.0)
    text.flatness = 0.01
    text.firstMaterial?.diffuse.contents = UIColor.white
        text.alignmentMode = CATextLayerAlignmentMode.center.rawValue

    
    let textNode = SCNNode(geometry: text)
    
    let fontSize = Float(0.04)
    textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
    textNode.position.y = 0.6
    textNode.position.x = -0.4
    textNode.eulerAngles.y = ((sceneView.session.currentFrame?.camera.eulerAngles.y)!)
    textNode.name = "S50"

    return textNode
    }
    
    func loadS100() -> SCNNode {
        
        let text = SCNText(string: "Score: 100", extrusionDepth: 0.1)
        text.font = UIFont.systemFont(ofSize: 4.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.white
        text.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        
        let textNode = SCNNode(geometry: text)
        
        let fontSize = Float(0.04)
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)
        textNode.position.y = 0.6
        textNode.position.x = -0.4
        textNode.eulerAngles.y = ((sceneView.session.currentFrame?.camera.eulerAngles.y)!)
        textNode.name = "S100"

        return textNode
    }
    
    
}

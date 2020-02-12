/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity
import Foundation
import SpriteKit
import CoreMotion
import CoreGraphics

class globVar{
 
    var count = 0
    var score = 0
    
    var entries: NSArray = []
    
}


/*
class globVar: NSObject, NSCoding{
    
    var count = 0
    var score = 0
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        count = aDecoder.decodeObject(forKey: "count") as! Int
        score = aDecoder.decodeObject(forKey: "score") as! Int
        
        //self.count = aDecoder.decodeFloat(forKey: "count") as Float
        //self.score = aDecoder.decodeFloat(forKey: "score") as Float
        
      
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(count, forKey: "count")
        aCoder.encode(score, forKey: "score")
    }
    
    
}

*/

/*
class globVar:  NSObject, NSCoding, Codable {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(count, forKey: "count")
        aCoder.encode(score, forKey: "score")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        let count = aDecoder.decodeObject(forKey: "count") as? Int
        let score = aDecoder.decodeObject(forKey: "score") as? Int
        
        
        
        self.count = aDecoder.decodeInteger(forKey: "count")
        self.score = aDecoder.decodeInteger(forKey: "score")
        
        super.init()
    }
    
    

    var count:Int
    var score:Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case score
 
    }
 
    init(count:Int,score:Int) {
        self.count = count
        self.score = score

    
}


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(count, forKey: .count)
        try container.encode(score, forKey: .score)
    }


    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decode(Int.self, forKey: .count)
        score = try container.decode(Int.self, forKey: .score)
        
    }
    
}
*/


var gV = globVar()
var lastNode = SCNNode(geometry: SCNBox(width: 0, height: 0, length: 0, chamferRadius: 0))
var countdown = 15
var timer: Timer!
var handAnchor: ARAnchor!
let steam = SCNParticleSystem(named: "smoke", inDirectory: nil)

let frameLabel:CGRect = CGRect(x: 20, y: 50, width: UIScreen.main.bounds.width - 40, height: 100)
let label: UILabel = UILabel(frame:frameLabel)





class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    // MARK: - IBOutlets
    
    @IBOutlet weak var sessionInfoView: UIView!
    @IBOutlet weak var sessionInfoLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var sendMapButton: UIButton!
    @IBOutlet weak var mappingStatusLabel: UILabel!
    @IBOutlet weak var scoreView: UIView!
    
    @IBOutlet weak var scoreLAbel: UILabel!
    
    
    @IBOutlet weak var step1: UILabel!
    
    
    @IBOutlet weak var step2: UILabel!
    
    var steppo = "Place OVEN on the floor"
    
    
    // MARK: - View Life Cycle
    
    var multipeerSession: MultipeerSession!
    
    override func viewDidLoad() {
        view.sendSubviewToBack(scoreView)
        super.viewDidLoad()
        step1.isHidden = true
        step2.isHidden = true
        
        gV.entries = [gV.count, gV.score]
        
        
       // NSData *data = [NSKeyedArchiver archivedDataWithRootObject:entries]

        
        lastNode.name = "MT"
        
        var handTransform = (sceneView.pointOfView?.simdTransform)!
        handTransform.columns.3.x = 0
        handTransform.columns.3.x = 0
        handTransform.columns.3.x = 0

        
        //handAnchor = ARAnchor(name: "handAnchor", transform: handTransform)
        
        
        
        
        multipeerSession = MultipeerSession(receivedDataHandler: receivedData)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        // Start the view's AR session.
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
        
        // Set a delegate to track the number of plane anchors for providing UI feedback.
        sceneView.session.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    /// - Tag: CheckMappingStatus
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        switch frame.worldMappingStatus {
        case .notAvailable, .limited:
            sendMapButton.isEnabled = false
        case .extending:
            sendMapButton.isEnabled = !multipeerSession.connectedPeers.isEmpty
        case .mapped:
            sendMapButton.isEnabled = !multipeerSession.connectedPeers.isEmpty
        }
        mappingStatusLabel.text = frame.worldMappingStatus.description
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        sessionInfoLabel.text = "Session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        sessionInfoLabel.text = "Session interruption ended"
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user.
        sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
        resetTracking(nil)
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    var countdown = 15

    
    func sendAnchor(anchor: ARAnchor)
    {
        // Send the anchor info to peers, so they can place the same content.
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true)
            else { fatalError("can't encode anchor") }
        self.multipeerSession.sendToAllPeers(data)
        
    }
    
    
    func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "doughShelf"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    func getParent1(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "tomatoShelf"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    func getParent2(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "cheeseShelf"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    func getParent3(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "rolling"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    func getParent4(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "cutting"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    func getParent5(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "grating"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    func getParent6(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "saucing" || node.name == "inPot"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    func getParent7(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "sauceInPot"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    func getParent8(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "bowl"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    func getParent9(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "pizzaOven"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }

    func getParent10(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == "winNode"{
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }


    
    
    
    
    
    
    

    /// - Tag: PlaceCharacter
    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        
        // Hit test to find a place for a virtual object.
        guard let hitTestResult = sceneView
            .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane, .estimatedVerticalPlane, .featurePoint])
            .first
            else { return }
        
        
        
        switch gV.count
        {
        case 0 :
            
            let anchor = ARAnchor(name: "oven", transform: hitTestResult.worldTransform)
            sceneView.session.add(anchor: anchor)
            sendAnchor(anchor: anchor)
            gV.count = 1
            
            steppo = "Place SHELF on the floor"
            
            let co = gV
            
1
            
        case 1 :
            
            let anchor = ARAnchor(name: "shelf", transform: hitTestResult.worldTransform)
            sceneView.session.add(anchor: anchor)
            sendAnchor(anchor: anchor)
            gV.count = 2
            
            steppo = "Place WORKSTATION on a table"
            
            let co = gV.count
            
          
        case 2 :
            
            let anchor = ARAnchor(name: "workstation", transform: hitTestResult.worldTransform)
            sceneView.session.add(anchor: anchor)
            sendAnchor(anchor: anchor)
            gV.count = 3
          
            steppo = "Place WINDOW on a wall"
            
            
        case 3 :
            
            let anchor = ARAnchor(name: "window", transform: hitTestResult.worldTransform)
            sceneView.session.add(anchor: anchor)
            sendAnchor(anchor: anchor)
            gV.count = 4
            
            steppo = ""


            
            
        case 4:
            // HIT TESTIN TIME
            let touch = sceneView.hitTest(sender.location(in: sceneView), options: nil).first
            
            let location = touch?.node
            
                if let node = getParent(location)
                {
                    //smallTimer()
                    print("howdy")
                    lastNode = loadDoughModel()
                    lastNode.name = "dough"
                    lastNode.position = SCNVector3Make(0, -1, -5)
                    sceneView.pointOfView?.addChildNode(lastNode)
                    
                    //printlastNode.name!
                    gV.score = gV.score + 1
                    print (gV.score)
                    var scoreRoot = gV
                    
                    
                }
            
                if let node = getParent1(location)
                {
                
                    lastNode = loadTomatoModel()
                    lastNode.position = SCNVector3Make(0, -1, -5)
                    lastNode.name = "tomato"
                    sceneView.pointOfView?.addChildNode(lastNode)
                    
                }
            
            if let node = getParent2(location)
            {
              
                    lastNode = loadCheeseModel()
                    lastNode.name = "cheese"
                    lastNode.position = SCNVector3Make(0, -1, -5)
                    sceneView.pointOfView?.addChildNode(lastNode)

            }
            
            if let node = getParent3(location)
            {
                if lastNode.name == "dough"
                {
                    lastNode.scale = SCNVector3Make(2.0, 0.25, 2.0)
                    lastNode.name = "doughFlat"
                }
            }
            
            if let node = getParent4(location)
            {
                if lastNode.name == "tomato"
                {
                    lastNode.removeFromParentNode()
                    lastNode = loadTomatoSlicedModel()
                    lastNode.name = "tomatoSliced"
                    lastNode.position = SCNVector3Make(0, -1, -5)
                    lastNode.scale = SCNVector3Make(0.4, 0.4, 0.4)
                    sceneView.pointOfView?.addChildNode(lastNode)
                }
            }
            if let node = getParent5(location)
            {
                if lastNode.name == "cheese"
                {
                    lastNode.removeFromParentNode()
                    
                    for anchor in sceneView.session.currentFrame!.anchors{
                        if anchor.name == "wrks" || anchor.name == "workstation"
                        {
                            var AT = anchor.transform
                            sceneView.session.remove(anchor: anchor)
                            sceneView.session.add(anchor: ARAnchor(name: "wrksc", transform: AT))
                            
                            
                        }
                    }
                    
                    
                    /*
                    lastNode = loadCheeseShredModel()
                    lastNode.name = "cheeseShred"
                    lastNode.position = SCNVector3Make(0, -1, -5)
                    lastNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
                    lastNode.eulerAngles = SCNVector3Make(0.5,0.0,0.0)
                    

                    sceneView.pointOfView?.addChildNode(lastNode)
 */
                }
            }
            if let node = getParent6(location)
            {
                if lastNode.name == "tomatoSliced"
                {
                    lastNode.removeFromParentNode()
                    
                    
                    for anchor in sceneView.session.currentFrame!.anchors{
                        if anchor.name == "workstation"
                        {
                            var AT = anchor.transform
                            sceneView.session.remove(anchor: anchor)
                            sceneView.session.add(anchor: ARAnchor(name: "wrks", transform: AT))
                            
                        }
                    }
                    
                }
            }
            if let node = getParent7(location)
            {
                if lastNode.name == "doughFlat"
                {
                    lastNode.addChildNode(loadSauceModel())
                    
                    
                
                    
                }
            }
            if let node = getParent8(location)
            {
                if lastNode.name == "doughFlat"
                {
                    lastNode.addChildNode(loadMozzModel())
                    
                    
                    
                    
                }
            }
            if let node = getParent9(location)
            {
                if lastNode.name == "doughFlat"
                {
                    
                    
                    lastNode.addParticleSystem(steam!)
                    //lastNode.removeFromParentNode()
                    
                }
            }
            
            if let node = getParent10(location)
            {
                if lastNode.name == "doughFlat"
                {
                    if lastNode.childNodes.contains(loadMozzModel())
                    {
                        gV.score += 50
                    }
                    if lastNode.childNodes.contains(loadSauceModel())
                    {
                        gV.score += 50
                    }
                    
                    lastNode.removeFromParentNode()
                    gV.count = 5
                    scoreLAbel.text = "Score: " + String(gV.score)

                    for anchor in sceneView.session.currentFrame!.anchors{
                        if anchor.name == "s0"
                        {
                            var AT = anchor.transform
                            sceneView.session.remove(anchor: anchor)
                            sceneView.session.add(anchor: ARAnchor(name: "s100", transform:AT))
                        }
                    }
                    
                }
            }
        default:
            scoreView.isHidden = false
            view.bringSubviewToFront(scoreView)
            
        
            return
        }
        
    }
        
        
        // Place an anchor for a virtual character. The model appears in renderer(_:didAdd:for:).
    

    


        
        
        
        
        
        
        
    
    
    
    ///////
    
    /// - Tag: GetWorldMap
    @IBAction func shareSession(_ button: UIButton) {
        sceneView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("can't encode map") }
            self.multipeerSession.sendToAllPeers(data)
        }
    }
            
        
    
    var mapProvider: MCPeerID?

    /// - Tag: ReceiveData
    func receivedData(_ data: Data, from peer: MCPeerID) {
        
        do {
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
            {
                // Run the session with the received world map.
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = [.horizontal,.vertical]
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
         
                // Remember who provided the map for showing UI feedback.
                mapProvider = peer
                gV.count = 4
                //steppo = ""
            }
            else
            if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data)
            {
                // Add anchor to the session, ARSCNView delegate adds visible content.
                sceneView.session.add(anchor: anchor)
            }
        } catch {
            print("can't decode data recieved from \(peer)")
        }
    }
    
    // MARK: - AR session management
    
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty && multipeerSession.connectedPeers.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "Move around to map the environment, or wait to join a shared session."
            
        case .normal where !multipeerSession.connectedPeers.isEmpty && mapProvider == nil:
            let peerNames = multipeerSession.connectedPeers.map({ $0.displayName }).joined(separator: ", ")
            message = "Connected with \(peerNames)."
            
        case .notAvailable:
            message = "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            message = "Move more slowly"
            
        case .limited(.insufficientFeatures):
            message = "Low visibility."
            
        case .limited(.initializing) where mapProvider != nil,
             .limited(.relocalizing) where mapProvider != nil:
            message = "Received map from \(mapProvider!.displayName)."
            
        case .limited(.relocalizing):
            message = "Relocalizing."
            
        case .limited(.initializing):
            message = "Initializing AR session"
            
        default:
            // No feedback needed when tracking is normal and planes are visible.
            // (Nor when in unreachable limited-tracking states.)
            message = steppo
            
        }
        
        sessionInfoLabel.text = message
        sessionInfoView.isHidden = message.isEmpty
        
       
        
    }
    
    @IBAction func resetTracking(_ sender: UIButton?) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        gV.count = 0
    }
    
    
    
    
    
 
}


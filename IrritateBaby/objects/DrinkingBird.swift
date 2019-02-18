import SceneKit
import ARKit
import UIKit

class DrinkingBird {
    
    let coreNode: SCNNode
    let supportColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1)
    let sphereColor = UIColor(red: 160, green: 0, blue: 0, alpha: 1)
    let cylinderColor = UIColor(red: 0, green: 0, blue: 208, alpha: 1)
    
    init(_ cameraTransform: simd_float4x4) {
        self.coreNode = SCNNode()
        coreNode.simdTransform = cameraTransform
    }
    
    func generateDrinkingBird() -> SCNNode {
        createSupport()
        createBody()
        createHead()
        return coreNode
    }
    
    
    func createHead() {
        
        let sphereHeight: CGFloat = 1.04/2
        let hatHeight: CGFloat = 0.7
        let brimHeight: CGFloat = 0.1
        
        let sphere = SCNSphere(radius: sphereHeight)
        sphere.firstMaterial?.diffuse.contents = sphereColor
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position.x = 0
        sphereNode.position.y = 1.6 + 3.9
        sphereNode.position.z = 0
        coreNode.addChildNode(sphereNode)
        
        let cylinderHat = SCNCylinder(radius: 0.8/2, height: hatHeight) // 80/2, 80/2, hatHeight
        cylinderHat.firstMaterial?.diffuse.contents = cylinderColor
        cylinderHat.firstMaterial?.diffuse.contents = sphereColor
        let hatNode = SCNNode(geometry: cylinderHat)
        hatNode.position.x = 0
        hatNode.position.y = Float(hatHeight)/2 + (1.6+3.9) + 0.4 + 0.1
        hatNode.position.z = 0
        coreNode.addChildNode(hatNode)
        
        let cylinderBrim = SCNCylinder(radius: 1.42/2, height: brimHeight)
        cylinderBrim.firstMaterial?.diffuse.contents = cylinderColor
        let brimNode = SCNNode(geometry: cylinderBrim)
        brimNode.position.x = 0
        brimNode.position.y = Float(brimHeight)/2 + (1.6+3.9) + 0.4
        brimNode.position.z = 0
        coreNode.addChildNode(brimNode)
    }
    
    
    func createBody() {
        let sphereRadius: CGFloat = 1.16/2
        let cylinderHeight: Float = 0.39
        
        let sphere = SCNSphere(radius: sphereRadius)
        sphere.firstMaterial?.diffuse.contents = sphereColor
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position.x = 0
        sphereNode.position.y = 1.6
        sphereNode.position.z = 0
        coreNode.addChildNode(sphereNode)
        
        let cylinder = SCNCylinder(radius: 0.024/2, height: 0.32)
        cylinder.firstMaterial?.diffuse.contents = cylinderColor
        let cylinderNode = SCNNode(geometry: cylinder)
        cylinderNode.position.x = 0
        cylinderNode.position.y = cylinderHeight/2 + 0.16
        cylinderNode.position.z = 0
        coreNode.addChildNode(cylinderNode)
    }
    
    func createSupport() {
        
        let baseWidthX: CGFloat = 0.2 + 0.64 + 1.1
        let baseWidthZ: CGFloat = 2 * 0.77
        let bevelRadius: CGFloat = 0.019
        
        // base
        let boxBase = SCNBox(width: baseWidthX, height: 0.04, length: baseWidthZ, chamferRadius: bevelRadius)
        boxBase.firstMaterial?.diffuse.contents = supportColor
        let boxNodeBase = SCNNode(geometry: boxBase)
        boxNodeBase.position.x = -0.45 // (20+32) - half of width (20+64+110)/2
        boxNodeBase.position.y = 0.04/2 // half of height
        boxNodeBase.position.z = 0
        coreNode.addChildNode(boxNodeBase)
        
        // left foot
        let boxLF = SCNBox(width: 0.2+0.64+1.1, height: 0.52, length: 0.06, chamferRadius: bevelRadius)
        boxLF.firstMaterial?.diffuse.contents = supportColor
        let boxNodeLF = SCNNode(geometry: boxLF)
        boxNodeLF.position.x = -0.45 // (20+32) - half of width (20+64+110)/2
        boxNodeLF.position.y = 0.52/2 // half of height
        boxNodeLF.position.z = 0.77 + 0.06/2    // offset 77 + half of depth 6/2
        coreNode.addChildNode(boxNodeLF)
        
        // left leg
        let boxLL = SCNBox(width: 0.2+0.64+1.1, height: 0.52, length: 0.06, chamferRadius: bevelRadius)
        boxLL.firstMaterial?.diffuse.contents = supportColor
        let boxNodeLL = SCNNode(geometry: boxLL)
        boxNodeLL.position.x = 0 // centered on origin along X
        boxNodeLL.position.y = (334+52)/2
        boxNodeLL.position.z = 77 + 0.06/2    // offset 77 + half of depth 6/2
        coreNode.addChildNode(boxNodeLL)
        
        // right foot
        let boxRF = SCNBox(width: 0.64, height: 1.04, length: 0.06, chamferRadius: bevelRadius)
        boxRF.firstMaterial?.diffuse.contents = supportColor
        let boxNodeRF = SCNNode(geometry: boxRF)
        boxNodeRF.position.x = -0.45 // (20+32) - half of width (20+64+110)/2
        boxNodeRF.position.y = 0.52/2
        boxNodeRF.position.z = -(0.77 + 0.06/2)    // offset 77 + half of depth 6/2
        coreNode.addChildNode(boxNodeRF)
        
        // right leg
        let boxRL = SCNBox(width: 0.64, height: 1.04, length: 0.06, chamferRadius: bevelRadius)
        boxRL.firstMaterial?.diffuse.contents = supportColor
        let boxNodeRL = SCNNode(geometry: boxRL)
        boxNodeRL.position.x = 0
        boxNodeRL.position.y = (3.34+0.52)/2
        boxNodeRL.position.z = -(0.77 + 0.06/2)
        coreNode.addChildNode(boxNodeRL)
    }
    
    
    func addNodeToRoot(geometry: SCNGeometry, x: Float, y: Float, z: Float) {
        let node = SCNNode(geometry: geometry)
        node.position.x = x
        node.position.y = y
        node.position.z = z
        coreNode.addChildNode(node)
    }
}

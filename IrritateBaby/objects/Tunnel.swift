import SceneKit
import ARKit
import UIKit

class Tunnel {
    
    let object: SCNGeometry
    let numOfObject: Int
    var tunnelRadius = 0.5
    var plots: [SCNVector3]?
    
    init(_ object: SCNGeometry, _ plots: [SCNVector3]? = nil, numOfObject: Int = 16) {
        self.object = object
        self.numOfObject = numOfObject
        self.plots = plots
    }
    
    func generateTunnel(_ cameraTransform: simd_float4x4) -> SCNNode {
        let coreNode = generateOneRing(cameraTransform)
        
        // HitTestで二点を取得してそこに配置する方法
//        let numOfRings = 10
//        let tmpNode = coreNode.clone()
//        for i in 1..<numOfRings {
//            let node = tmpNode.clone()
//            node.position.x = plots[i-1].x
//            node.position.y = plots[i-1].y
//            node.position.z -= plots[i-1].z
//            coreNode.addChildNode(node)
//        }
//        return coreNode

//        let numOfRings = 10
//        let tmpNode = coreNode.clone()
//        for i in 1..<numOfRings {
//            let node = tmpNode.clone()
//            node.position.z = node.position.z - Float(1 * i)
//            coreNode.addChildNode(node)
//        }

        let numOfRings = 10
        for i in 1..<numOfRings {
            let node = generateOneRing(cameraTransform)
            node.position.z = node.position.z - Float(1 * i)
            coreNode.addChildNode(node)
        }

        
        // CameraTransformの座標とWorld座標とで意図しない方を参照している可能性
//        let numOfRings = 10
//        for i in 1..<numOfRings {
//            var newTransform = cameraTransform
//            newTransform.columns.3.z = cameraTransform.columns.3.z - Float(1 * i)
//            coreNode.addChildNode(generateOneRing(newTransform))
//        }
//
        return coreNode
    }
    
//    func generateOnceTunnel(_ cameraTransform: simd_float4x4) -> SCNNode {
//        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "material4.png")!
//        box.materials = [material]
//
//        let coreNode = SCNNode(geometry: box)
//        coreNode.simdTransform = cameraTransform
//
//        for i in 0..<numOfObject {
//            let ratioOfPos = Double(i) / Double(numOfObject)
//            let r = Double(ratioOfPos * 2.0 * Double.pi)
//            let x = Float(cos(r))
//            let y = Float(sin(r))
//
//            let sphereNode = SCNNode(geometry: object)
//            sphereNode.position = SCNVector3Make(coreNode.position.x + x, coreNode.position.y + y, coreNode.position.z)
//            coreNode.addChildNode(sphereNode)
//            for i in 1..<10 {
//                let copy = sphereNode.clone()
//                copy.position = SCNVector3Make(coreNode.position.x + x, coreNode.position.y + y, coreNode.position.z - (Float(i) * 0.2))
//                coreNode.addChildNode(copy)
//            }
//        }
//
//        return coreNode
//    }
    
    private func generateOneRing(_ cameraTransform: simd_float4x4) -> SCNNode {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIImage(named: "material4.png")!
        box.materials = [boxMaterial]
        let coreNode = SCNNode(geometry: box)
        coreNode.simdTransform = cameraTransform
        
        for i in 0..<numOfObject {
            let ratioOfPos = Double(i) / Double(numOfObject)
            let r = Double(ratioOfPos * 2.0 * Double.pi)
            let x = Float(cos(r))
            let y = Float(sin(r))
            
            let node = SCNNode(geometry: object)
            node.position = SCNVector3Make(coreNode.position.x + x, coreNode.position.y + y, coreNode.position.z)
            coreNode.addChildNode(node)
        }
        
        return coreNode
    }
}

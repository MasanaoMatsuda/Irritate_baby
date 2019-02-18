//
//  ViewController.swift
//  IrritateBaby
//
//  Created by Masanao Matsuda on 2019/01/08.
//  Copyright © 2019 Masanao Matsuda. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class NavigatorViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var button: UIButton!
    
    let materials = [UIImage(named: "material1.png")!,
                     UIImage(named: "material2.png")!,
                     UIImage(named: "material3.png")!,
                     UIImage(named: "material4.png")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @IBAction func startDidTap(_ sender: Any) {
        //        // Get Camera Transform
        //        let camera = sceneView.session.currentFrame?.camera
        //        let cameraTransformOrigin = camera?.transform
        //
        //        guard let cameraTransform = cameraTransformOrigin else {
        //            return
        //        }
        //
        //        let objectSize: CGFloat = 0.05
        //        let material = SCNMaterial()
        //        material.diffuse.contents = materials[1]
        //        let sphere = SCNSphere(radius: objectSize)
        //        sphere.materials = [material]
        //
        //        let tunnel = Tunnel(sphere)
        //        let coreNode = tunnel.generateTunnel(cameraTransform)
        //        sceneView.scene.rootNode.addChildNode(coreNode)
        
        removeAllNodes()
        
        // Z軸の問題解決
        let material = SCNMaterial()
        material.diffuse.contents = materials[1]

        guard let pointOfView = sceneView.pointOfView else { return }
        let matrix = pointOfView.transform
        let unitDirect = SCNVector3(-1 * matrix.m31, -1 * matrix.m32, -1 * matrix.m33)


        let count = 10
        
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIImage(named: "material3.png")!
        for i in 1..<count+1 {
            if i == count {
                let duckNode = generateDuck()
                duckNode.transform = matrix
                duckNode.position.x = pointOfView.position.x + (unitDirect.x * Float(i))
                duckNode.position.y = pointOfView.position.y + (unitDirect.y * Float(i))
                duckNode.position.z = pointOfView.position.z + (unitDirect.z * Float(i))
                sceneView.scene.rootNode.addChildNode(duckNode)
                break
            }
            
            let ringNode = generateRing(material, sphereMaterial, unitDirect)
            ringNode.transform = matrix
            ringNode.position.x = pointOfView.position.x + (unitDirect.x * Float(i))
            ringNode.position.y = pointOfView.position.y + (unitDirect.y * Float(i))
            ringNode.position.z = pointOfView.position.z + (unitDirect.z * Float(i))
            sceneView.scene.rootNode.addChildNode(ringNode)
        }
    }
    
    @IBAction func onViewTapped(_ sender: UITapGestureRecognizer) {
        let material = SCNMaterial()
        material.diffuse.contents = materials[2]
        
        let boxNode = hitBoxTesting(sender)
        boxNode?.geometry?.materials = [material]
        
        //        if let boxNode = boxNode {
        //
        //            let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 1)
        //            let node = SCNNode(geometry: box)
        //            node.transform = boxNode.transform
        //            let material = SCNMaterial()
        //            material.diffuse.contents = materials[2]
        //            node.geometry?.materials = [material]
        //
        //            sceneView.scene.rootNode.addChildNode(node)
        //        }
        
        //            let boxPoint = SCNVector3Make(boxNode.position.x, boxNode.position.y, boxNode.position.z)
        //            let plots = getPlots(boxPoint)
        //            let targetPoint = plots.prefix(5).last
        //
        //            if let targetPoint = targetPoint {
        //                let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 1)
        //                let node = SCNNode(geometry: box)
        //                node.position.x = targetPoint.x
        //                node.position.y = targetPoint.y
        //                node.position.z = targetPoint.z
        //                let material = SCNMaterial()
        //                material.diffuse.contents = materials[2]
        //                node.geometry?.materials = [material]
        //
        //                sceneView.scene.rootNode.addChildNode(node)
        //            }
        //        }
        print("Fin")
    }
    
    
    // MARK: - ARSCNViewDelegate
    
    /*
     Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    private func hitBoxTesting(_ sender: UITapGestureRecognizer) -> SCNNode? {
        // Get Hit Tested Point Vector translated to World Coordinate
        let tapPoint = sender.location(in: sceneView)
        let results = sceneView.hitTest(tapPoint, options: [:])
        let hitResult = results.first
        
        if let result = hitResult {
            if result.node.geometry is SCNSphere {
                print("this is sphere")
                return nil
            }
            
            return result.node
        }
        
        return nil
    }
    
    private func getPlots(_ targetPoint: SCNVector3) -> [SCNVector3] {
        // Get Camera Point of vector
        let camera = sceneView.session.currentFrame?.camera
        let cameraTransform = camera?.transform
        
        var plots: [SCNVector3] = []
        
        if let cameraTransform = cameraTransform {
            let cameraPoint = SCNVector3.init(cameraTransform.columns.3.x,
                                              cameraTransform.columns.3.y,
                                              cameraTransform.columns.3.z)
            
            let position = SCNVector3Make(cameraPoint.x - targetPoint.x,
                                          cameraPoint.y - targetPoint.y,
                                          cameraPoint.z - targetPoint.z)
            let unitX = position.x / 10
            let unitY = position.y / 10
            let unitZ = position.z / 10
            
            print(unitX)
            print(unitY)
            print(unitZ)
            
            for i in 1..<10 {
                let plot = SCNVector3Make(unitX * Float(i), unitY * Float(i), unitZ * Float(i))
                plots.append(plot)
                print(i)
            }
        }
        return plots
    }
    
    
    private func generateRing(_ boxMaterial: SCNMaterial, _ sphereMaterial: SCNMaterial, _ unitDirect: SCNVector3) -> SCNNode {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        box.materials = [boxMaterial]
        let newNode = SCNNode(geometry: box)
        
        let numOfObject = 24
        for i in 0..<numOfObject {
            let ratioOfPos = Double(i) / Double(numOfObject)
            let r = Double(ratioOfPos * 2.0 * Double.pi)
            let x = Float(cos(r))
            let y = Float(sin(r))
            
            let sphere = SCNSphere(radius: 0.1)
            sphere.materials = [sphereMaterial]
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.position = SCNVector3Make(newNode.position.x + x, newNode.position.y + y, newNode.position.z)
            newNode.addChildNode(sphereNode)
        }
        return newNode
    }
    
    private func generateDuck() -> SCNNode {
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.red
        let yellowMaterial = SCNMaterial()
        yellowMaterial.diffuse.contents = UIColor.yellow
        let blackMaterial = SCNMaterial()
        blackMaterial.diffuse.contents = UIColor.black
        
        let eyeSphere = SCNSphere(radius: 0.01)
        eyeSphere.materials = [blackMaterial]
        let rightEyeNode = SCNNode(geometry: eyeSphere)
        rightEyeNode.position = SCNVector3Make(0.1, 0.1, 0.3)
        let leftEyeNode = SCNNode(geometry: eyeSphere)
        leftEyeNode.position = SCNVector3Make(-0.1, 0.1, 0.3)
        
        let beakCone = SCNCone(topRadius: 0.0, bottomRadius: 0.1, height: 0.2)
        beakCone.materials = [redMaterial]
        let beakNode = SCNNode(geometry: beakCone)
        beakNode.eulerAngles.x = .pi/2
        beakNode.eulerAngles.z = .pi/2
        beakNode.position = SCNVector3Make(0.0, 0.0, 0.3)
        
        let headSphere = SCNSphere(radius: 0.3)
        headSphere.materials = [yellowMaterial]
        let headNode = SCNNode(geometry: headSphere)
        headNode.position = SCNVector3Make(0.0, 0.7, 0.1)
        headNode.addChildNode(rightEyeNode)
        headNode.addChildNode(leftEyeNode)
        headNode.addChildNode(beakNode)
        
        let bodySphere = SCNSphere(radius: 0.5)
        bodySphere.materials = [yellowMaterial]
        let bodyNode = SCNNode(geometry: bodySphere)
        bodyNode.addChildNode(headNode)
        return bodyNode
    }
    
    private func removeAllNodes() {
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    //    private func oldMethod() {
    //                // Clear All Node
    //                sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
    //                    node.removeFromParentNode()
    //                }
    //
    //                // Get Hit Tested Point Vector translated to World Coordinate
    //                let tapPoint = sender.location(in: sceneView)
    //                let results = sceneView.hitTest(tapPoint, types: .featurePoint)
    //                let hitPoint = results.first
    //
    //                guard let point = hitPoint else {
    //                    return
    //                }
    //                let worldPoint = SCNVector3.init(point.worldTransform.columns.3.x,
    //                                                 point.worldTransform.columns.3.y,
    //                                                 point.worldTransform.columns.3.z)
    //
    //                // Plot list between two points
    //                let plots = getPlots(worldPoint)
    //
    //                // Generate Object and Set to Node
    //                let objectSize: CGFloat = 0.05
    //                let material = SCNMaterial()
    //                material.diffuse.contents = materials[1]
    //                let sphere = SCNSphere(radius: objectSize)
    //                sphere.materials = [material]
    //
    //                //            let bird = DrinkingBird(cameraTransform)
    //                //            let birdNode = bird.generateDrinkingBird()
    //
    //                let tunnel = Tunnel(sphere, plots)
    //                let coreNode = tunnel.generateTunnel(cameraTransform)
    //                //let coreNode = tunnel.generateOnceTunnel(cameraTransform)
    //                //            coreNode.addChildNode(birdNode)
    //                sceneView.scene.rootNode.addChildNode(coreNode)
    //    }
}

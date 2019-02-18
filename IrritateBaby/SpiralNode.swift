//
//  SpiralNode.swift
//  IrritateBaby
//
//  Created by Masanao Matsuda on 2019/01/08.
//  Copyright © 2019 Masanao Matsuda. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class SpiralNode: SCNNode {
    var radius: CGFloat = 10
    var spiralRadius: Int = 0
    var spiralLength: Int = 0
    
    override init() {
        super.init()
        geometry = SCNSphere(radius: radius)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

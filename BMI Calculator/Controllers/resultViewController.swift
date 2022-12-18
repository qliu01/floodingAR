//
//  resultViewController.swift
//  BMI Calculator
//
//  Created by Qing Liu on 10/18/22.
//  Copyright © 2022 Qing Liu. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class resultViewController: UIViewController,ARSCNViewDelegate {
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
//        sceneView.delegate = self
                
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        // Do any additional setup after loading the view.
        
//        let scene = SCNScene()
//
//        // 2.1.想要绘制的 3D 立方体
//        let boxGeometry=SCNBox(width:0.1,height:0.1,length:0.1,chamferRadius:0.0)
//        //ARKit 中的坐标单位为米，所以我们就创建了一个 10x10x10 厘米的盒子。
//
//        // 2.2.将几何体包装为node以便添加到scene
//        let boxNode = SCNNode(geometry: boxGeometry)
//
//        // 2.3.把box放在摄像头正前方
//        boxNode.position = SCNVector3Make(0, 0, -0.5)
//
//        // 3.rootNode是一个特殊的node，它是所有node的起始点
//        scene.rootNode.addChildNode(boxNode)
//
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "FloodingImage", bundle: Bundle.main) {
            
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages=1
            
            print("image found")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer:SCNSceneRenderer, nodeFor anchor: ARAnchor)->SCNNode?{
        
        let node=SCNNode()
        
        
        if let imageAnchor=anchor as? ARImageAnchor{
            //create videoNode
            let videoNode = SKVideoNode(fileNamed: "flooding.mp4")
            
            videoNode.play()
            
            let videoScene = SKScene(size: CGSize(width: 1920, height: 1080))
            
            
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            
            videoNode.yScale = -1.0
            
            videoScene.addChild(videoNode)
            
            
            //create plane for video
            let plane=SCNPlane(width:imageAnchor.referenceImage.physicalSize.width,height:imageAnchor.referenceImage.physicalSize.height)
//            plane.firstMaterial?.diffuse.contents=UIColor(white:1.0, alpha:0.5)
            plane.firstMaterial?.diffuse.contents=videoScene
            
            let planeNode=SCNNode(geometry:plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
        }
        
        return node
        
    
    }
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

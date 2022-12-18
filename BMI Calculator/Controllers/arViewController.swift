//
//  arViewController.swift
//  BMI Calculator
//
//  Created by Qing Liu on 10/18/22.
//  Copyright © 2022 Qing Liu. All rights reserved.
//

import UIKit
import ARKit

//这里要加上UICollectionViewDataSource 可以控制CollectionView
class arViewController: UIViewController, UICollectionViewDataSource , UICollectionViewDelegate, ARSCNViewDelegate{
    
    //用一个array来记录CollectionView中的cells 就是那些button
    let itemsArray: [String] = ["high building", "low building", "boxing", "maple tree","pine tree"]
    
    

    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    
    
    //配置
    let configuration = ARWorldTrackingConfiguration()
    //建立一个变量 存储当前被选中的item名称
    var selectedItem: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置view的options 要显示showWorldOrigin，showFeaturePoints
//        self.sceneView.debugOptions = [ ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
        
        //detecg the horizontal surfaces
        self.configuration.planeDetection = .horizontal
        
        //配置好后可以run the session
        self.sceneView.session.run(configuration)
        
        //后面cell的data来自dataSource
        self.itemsCollectionView.dataSource = self
        //保证后面detect CollectionView的cell可以用
        self.itemsCollectionView.delegate = self
//        addDice()

        let diceScene = SCNScene(named: "Models.scnassets/buildings.scn")!
                //create a node to put the diceScene
                //这个node是从Dice这个模型的位置得到的
        if let diceNode=diceScene.rootNode.childNode(withName: "buildings", recursively:true){
            diceNode.position=SCNVector3(x: 0, y: -10, z: -30)
            sceneView.scene.rootNode.addChildNode(diceNode)
        }        //load这个registerGestureRecognizers
        self.registerGestureRecognizers()
        self.sceneView.autoenablesDefaultLighting = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //detect user's tap
    func registerGestureRecognizers() {
        //这个UITapGestureRecognizer()中需要用selector指定
        //具体which function should be triggered when you tap on something 这里是trigger了tapped方法
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        
        //添加识别pinch的recognizer
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))//这里也需要指定trigger的方法 就是pinch
        
        //加上longPress的recognizer trigger的方法是rotate
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(rotate))
//        longPressGestureRecognizer.minimumPressDuration = 0.1

        //把这个pinchGestureRecognizer加到scene中
        
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        //放到scene中
        self.sceneView.addGestureRecognizer(longPressGestureRecognizer)
    }
    

    //上面已经把pinchGestureRecognizer加到scene中
    //这样一旦有pinch发生 这个recognizer作为sender会发信息
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        //获取pinch的location
        let pinchLocation = sender.location(in: sceneView)
        //获取具体在现实世界的位置
        let hitTest = sceneView.hitTest(pinchLocation)

        if !hitTest.isEmpty {

            let results = hitTest.first!
            //建立node
            let node = results.node
            //sender.scale就是recognizer获取的pinch的程度
            //就是how hard you pinch 你手动挤了多少
            //比如sender.scale=1.5就是放大1.5倍 如果是0.5就是缩小到0.5倍
            let pinchAction = SCNAction.scale(by: sender.scale, duration: 0)
            print(sender.scale)
            //就是执行这个scale的动作
            node.runAction(pinchAction)
            sender.scale = 1.0//这次scale完成后要回到1 否则就会以这次值为基础不准确
        }


    }

    
    @objc func tapped(sender: UITapGestureRecognizer) {
        
        let sceneView = sender.view as! ARSCNView
        //where the user tapped
        let tapLocation = sender.location(in: sceneView)
        //the location the user tapped->the locations in the real world in horizontal plane
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        if !hitTest.isEmpty {
            //print("touched a horizontal surface")
            self.addItem(hitTestResult: hitTest.first!)
        }
    }
    
    //把刚刚detect到的hitTestResult传进去 就是在这个位置add item
    func addItem(hitTestResult: ARHitTestResult) {
        //如果找得到这个user 选中的cell名字的model
        if let selectedItem = self.selectedItem {
            //找到这个具体的文件名 建立scene
            //模型的selectedItem部分一定要和cells名字一致
            let scene = SCNScene(named: "Models.scnassets/\(selectedItem).scn")
            //从这个scene建立node
            let node = (scene?.rootNode.childNode(withName: selectedItem, recursively: false))!
            //记得也要在x轴方向旋转一下这个物体
            let transform = hitTestResult.worldTransform
            let thirdColumn = transform.columns.3
            node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            
//            if selectedItem == "table" {
//                self.centerPivot(for: node)
//            }
            
            //加到整体scene中
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }
    //专门用来accessCollectionView的attributes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //获取当前选中的cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! itemCell
        
        //根据这个cell在array中的index 把名称赋给这个cell的text 所以cell可以显示名称
        cell.itemLabel.text = self.itemsArray[indexPath.row]
        return cell
    }
    
    //把选中的cell的颜色改为绿色
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //获取当前选中的cell
        let cell = collectionView.cellForItem(at: indexPath)//这个indexPath是我们选中的cell的index
        //
        self.selectedItem = itemsArray[indexPath.row]
        cell?.backgroundColor = UIColor.orange//把这个选中的cell颜色为绿色
    }
    //没选中的改为黄色
    //如果先select一个cell 有select了另外一个 那么第一个应该deselect
    //这就是上一个结束后 再按就执行这个
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.systemGray2
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
       
        
    }
    
   
    //如果detect到long press 会call这个方法
     @objc func rotate(sender: UILongPressGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let holdLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(holdLocation)
        if !hitTest.isEmpty {

            let result = hitTest.first!
            if sender.state == .began {
                let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 10)
                let forever = SCNAction.repeatForever(rotation)
                result.node.runAction(forever)
            } else if sender.state == .ended {
                result.node.removeAllActions()
            }
        }


    }
    
    
    func centerPivot(for node: SCNNode) {
        let min = node.boundingBox.min
        let max = node.boundingBox.max
        node.pivot = SCNMatrix4MakeTranslation(
            min.x + (max.x - min.x)/2,
            min.y + (max.y - min.y)/2,
            min.z + (max.z - min.z)/2
        )
    }
}

extension Int {

    var degreesToRadians: Double { return Double(self) * .pi/180}
}


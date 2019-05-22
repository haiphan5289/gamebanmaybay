//
//  GameScene.swift
//  gamebanmaybay
//
//  Created by HaiPhan on 5/22/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var plane: SKSpriteNode!
    var monster: SKSpriteNode!
    var bullet: SKSpriteNode!
    var topbackground: SKSpriteNode!
    var timer: Timer!
    enum vacham : UInt32 {
        case bullet = 1
        case plane = 2
        case monster = 3
        case topbackground = 4
    }
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        createplane()
        createbullet()
        createmonster()
//        createtopbackbround()
        timer = Timer.scheduledTimer(timeInterval:0.5, target: self, selector: #selector(createbullet), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(createmonster), userInfo: nil, repeats: true)
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(dichuyenplane), userInfo: nil, repeats: true)
        // Get label node from scene and store it for use later
        
        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
//    @objc func dichuyenplane(){
//        plane.position.y += 30
//    }
    //khởi tạo 1 back ground khi tới nới sẽ xoá viên đạn đi
    func createtopbackbround(){
        topbackground = SKSpriteNode(color: UIColor.blue, size: CGSize(width: self.frame.width, height: 50))
        topbackground.position = CGPoint(x: 0, y: self.view!.frame.height - 30)
        topbackground.physicsBody = SKPhysicsBody(rectangleOf: topbackground.size)
        topbackground.physicsBody?.isDynamic = false
        topbackground.physicsBody?.categoryBitMask = vacham.topbackground.rawValue
        topbackground.physicsBody?.contactTestBitMask = vacham.bullet.rawValue
        self.addChild(topbackground)
    }
    func createplane(){
        plane = SKSpriteNode(imageNamed: "plane.jpg")
        plane.position = CGPoint(x: 0, y: -self.view!.frame.height + 200)
        plane.size = CGSize(width: self.frame.size.width/5, height: self.frame.size.width/5)
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.isDynamic = false
        plane.physicsBody?.categoryBitMask = vacham.plane.rawValue
        plane.physicsBody?.contactTestBitMask = vacham.monster.rawValue
        self.addChild(plane)
    }
    @objc func createbullet(){
        bullet = SKSpriteNode(imageNamed: "bullet.jpg")
        bullet.position = plane.position
        bullet.size = CGSize(width: 30, height: 30)
        bullet.zPosition = -1
//        bullet.position.y += 10
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        //1 trong 2 các vật thể phải cso dynamic thì va chạm mới có tác dụng
        bullet.physicsBody?.isDynamic = true
        //tắt   hút của trái đất
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = vacham.bullet.rawValue
        bullet.physicsBody?.contactTestBitMask = vacham.monster.rawValue
        self.addChild(bullet)
        //tạo 1 action cho vien đạn lên vị trí y
        let actiondichuyen: SKAction = SKAction.moveTo(y: self.view!.frame.height, duration: 0.5)
        //thêm action remove
        let actionremove: SKAction = SKAction.removeFromParent()
        //sau khi action di chuyen hoàn thành se remove nó
        bullet.run(actiondichuyen) {
            self.bullet.run(actionremove)
        }
    }
    @objc func createmonster(){
        let positionx = Int.random(in: -200...200)
        monster = SKSpriteNode(imageNamed: "monster.jpg")
        monster.position = CGPoint(x: CGFloat(positionx), y: self.view!.frame.height)
        monster.size = CGSize(width: self.frame.width/5, height: self.frame.height/5)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.physicsBody?.isDynamic = true
        //tắt lực hút của trái đất
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.categoryBitMask = vacham.monster.rawValue
        monster.physicsBody?.contactTestBitMask = vacham.monster.rawValue
        self.addChild(monster)
        
        let actiondichuyen: SKAction = SKAction.moveTo(y: -self.view!.frame.height - 100, duration: 5)
        monster.run(actiondichuyen)
    }
    func createaffect(location: CGPoint){
        let path = Bundle.main.path(forResource: "fire", ofType: "sks")
        let file = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        file.position = location
        self.addChild(file)
        
        let scalmagic: SKAction = SKAction.scale(by: 0.2, duration: 0.5)
        let removemagic: SKAction = SKAction.removeFromParent()
        file.run(scalmagic) {
            file.run(removemagic)
        }

        
    }
    func didBegin(_ contact: SKPhysicsContact) {
//        if contact.bodyA.categoryBitMask == vacham.plane.rawValue || contact.bodyB.categoryBitMask == vacham.plane.rawValue {
//            if contact.bodyA.categoryBitMask == vacham.monster.rawValue || contact.bodyB.categoryBitMask == vacham.monster.rawValue {
//                print("hihi")
//                return
//            }
//        }
        if contact.bodyA.categoryBitMask == vacham.monster.rawValue || contact.bodyB.categoryBitMask == vacham.monster.rawValue {
            if contact.bodyA.categoryBitMask == vacham.bullet.rawValue || contact.bodyB.categoryBitMask == vacham.bullet.rawValue {
                let nodeA = contact.bodyA.node as! SKSpriteNode
                let nodeB = contact.bodyB.node as! SKSpriteNode
                nodeA.removeFromParent()
                nodeB.removeFromParent()
                createaffect(location: contact.contactPoint)
                return
            }
        }
//        if contact.bodyA.categoryBitMask == vacham.bullet.rawValue || contact.bodyB.categoryBitMask == vacham.bullet.rawValue {
//            if contact.bodyA.categoryBitMask == vacham.bullet.rawValue || contact.bodyB.categoryBitMask == vacham.bullet.rawValue {
//                xoavacham(node1: bullet, node2: bullet)
//
//                return
//            }
//        }
//        if contact.bodyA.categoryBitMask == vacham.topbackground.rawValue || contact.bodyB.categoryBitMask == vacham.topbackground.rawValue {
//            if contact.bodyA.categoryBitMask == vacham.bullet.rawValue || contact.bodyB.categoryBitMask == vacham.bullet.rawValue {
////                let node1 = contact.bodyA.node as! SKSpriteNode
////                let node2 = contact.bodyB.node as! SKSpriteNode
////                node1.removeFromParent()
////                node2.removeFromParent()
//                bullet.removeFromParent()
//                return
//            }
//        }
        
    }
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self))
            //mỗi lần chạm sẽ hiển thị mấy bay
//            plane.position = t.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self))
            plane.position = t.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

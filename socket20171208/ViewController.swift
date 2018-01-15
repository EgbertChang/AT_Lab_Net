//
//  ViewController.swift
//  socket20171208
//
//  Created by Egbert Chang on 08/12/2017.
//  Copyright © 2017 Aleph Tdu. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 200, height: 40))
        button.backgroundColor = UIColor.green
        button.setTitle("Send Message", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.addTarget(self, action: #selector(self.sendMessage), for: UIControlEvents.touchUpInside)
        
        
        let fileButton = UIButton(frame: CGRect(x: 100, y: 300, width: 200, height: 40))
        fileButton.backgroundColor = UIColor.black
        fileButton.setTitle("File Operation", for: UIControlState.normal)
        fileButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        fileButton.addTarget(self, action: #selector(self.fileOperation), for: UIControlEvents.touchUpInside)
        
        
        let bundleButton = UIButton(frame: CGRect(x: 100, y: 400, width: 200, height: 40))
        bundleButton.backgroundColor = UIColor.black
        bundleButton.setTitle("Bundle Operation", for: UIControlState.normal)
        bundleButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        bundleButton.addTarget(self, action: #selector(self.bundleOperation), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(button)
        self.view.addSubview(fileButton)
        self.view.addSubview(bundleButton)
    }
    
    
    @objc func sendMessage(sender: UIButton) {
        let send = send_sketch1()
        send.sendMessage()
    }
    
    @objc func fileOperation(sender: UIButton) {
        // 获取文件路径，创建文件，并写入文件
        let appHomePath = NSHomeDirectory()
        print(appHomePath)
        
        // 使用 FileManager 在document目录下创建文件夹和文件
        // 注：若已经在Direct文件夹下生成一个hi文件夹，想要把hi文件夹改成文件，是不能直接覆盖掉的，则需要把hi文件夹先手动删除再重新生成才可以
        
        let directPath = "\(NSHomeDirectory())/Documents/Direct"
        let hiPath = "\(directPath)/hi.txt"
        let content: String = "This is a test string ... 中国"
        let dataOfContent = content.data(using: String.Encoding.utf8)
        
        // create folder
        try! FileManager.default.createDirectory(atPath: directPath, withIntermediateDirectories: true, attributes: nil)
        #if true
            print("Enter Create")
            let createStat = FileManager.default.createFile(atPath: hiPath, contents: dataOfContent, attributes: nil)
            print(createStat)
        #else
            print("Enter Write")
            // write方法是NSString的方法
            let writeStat = try! content.write(toFile: hiPath, atomically: true, encoding: String.Encoding.utf8)
        #endif
        
        let imagePath = "\(directPath)/app.png"
        // let image = UIImage(named: "app.png")
        // let dataOfImage: Data = UIImagePNGRepresentation(image!)!
        #if true
            // try! dataOfImage.write(to: URL(fileURLWithPath: imagePath))
            let createImageStat = FileManager.default.createFile(atPath: imagePath, contents: Data(), attributes: nil)
            print(createImageStat)
        #else
            // let createStat = FileManager.default.createFile(atPath: imagePath, contents: dataOfImage, attributes: nil)
        #endif
        
    }
    
    
    @objc func bundleOperation(sender: UIButton) {
     
        // print(NSHomeDirectory())
        let directPath = "\(NSHomeDirectory())/Documents/Direct"
        let imagePath = "\(directPath)/car.jpeg"
        
        
        let newData = NSData.init(contentsOfFile: imagePath)
        let newimagePath = "\(directPath)/newcar.jpeg"
        // let newfileHandle = FileHandle.init(forWritingAtPath: newimagePath)
        // newfileHandle?.seekToEndOfFile()
        // newfileHandle?.write(newData! as Data)
        
        
        let image = UIImage.init(data: newData! as Data)
        let createImageStat = FileManager.default.createFile(atPath: newimagePath, contents: UIImageJPEGRepresentation(image!, 1), attributes: nil)
        print(createImageStat)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


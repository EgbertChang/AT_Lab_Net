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
        
        
        self.view.addSubview(button)
    }
    
    
    @objc func sendMessage(sender: UIButton) {
        let send = send_sketch1()
        send.sendMessage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


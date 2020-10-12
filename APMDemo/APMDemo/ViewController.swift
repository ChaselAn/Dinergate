//
//  ViewController.swift
//  APMDemo
//
//  Created by 安程 on 2020/8/14.
//  Copyright © 2020 ChaselAn. All rights reserved.
//

import UIKit
import Dinergate

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let a = UISwitch(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.addSubview(a)
        
//        let b = [1, 2]
//        let c = b[3]
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        Dinergate.showMenu()
    }


}


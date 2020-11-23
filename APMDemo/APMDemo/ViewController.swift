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

        let a = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        a.setTitle("show", for: .normal)
        a.setTitleColor(.blue, for: .normal)
        a.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        view.addSubview(a)
    }
    
    @objc private func buttonClicked() {
        Dinergate.showMenu()
    }

}


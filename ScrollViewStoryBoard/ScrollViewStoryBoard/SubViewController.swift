//
//  SubViewController.swift
//  ScrollViewStoryBoard
//
//  Created by youngjun choi on 2020/06/04.
//  Copyright © 2020 youngjun choi. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {

    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var MainImage: UIImageView!
    @IBOutlet weak var FirstButton: UIButton!
    @IBOutlet weak var SecondButton: UIButton!
    @IBOutlet weak var ThirdButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func test(_ sender: Any) {
        NSLog("test")
    }
//
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        return false
//    }
//
    
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        var hitTestView = super.hitTest(point, with: event)
//        if hitTestView == self { // 1.
//            hitTestView = nil
//        }
//        return hitTestView
//    }

    
}

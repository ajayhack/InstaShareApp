//
//  ExploreViewController.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 10/10/21.
//

import UIKit

class ExploreViewController: UIViewController {
   
    override func viewDidAppear(_ animated: Bool) {
        StateManageConstant.isOpenCameraContant = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
    }
}

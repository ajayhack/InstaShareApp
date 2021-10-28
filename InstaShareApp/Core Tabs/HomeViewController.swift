//
//  HomeViewController.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 10/10/21.
//

import UIKit
import Firebase
import SafariServices

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.configureNavBarItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //Method to add Instagram Logo and Add Post Button on Navigation Bar:-
    private func configureNavBarItems(){
        let addPostImage = UIImage(systemName: "plus.app")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Instagram", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: addPostImage, style: .done, target: self, action: nil)
    }
    
    @objc func toastMessage(){
        
    }
}

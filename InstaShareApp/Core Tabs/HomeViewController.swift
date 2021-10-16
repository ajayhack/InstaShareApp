//
//  HomeViewController.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 10/10/21.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkBasedOpenController()
    }
    
    private func checkBasedOpenController(){
        if Auth.auth().currentUser == nil {
            //Navigate to LoginViewController:-
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true)
        }else{
            //Navigate to HomeViewController:-
        }
    }
}

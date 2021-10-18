//
//  LoginViewController.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 16/10/21.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var termsOfServiceLabel: UILabel? = nil
    
    @IBOutlet weak var privacyPolicyLabel: UILabel? = nil
    
    @IBOutlet weak var createAccountLabel: UILabel? = nil
    
    @IBOutlet weak var passwordTF: UITextField? = nil
    
    @IBOutlet weak var usernameTF: UITextField? = nil
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //OnClick Gesture for Create Account Label
        let createTap = UITapGestureRecognizer(target: self, action: #selector(showSignUpController))
        createAccountLabel?.isUserInteractionEnabled = true
        createAccountLabel?.addGestureRecognizer(createTap)

        //OnClick Gesture for Terms of Service Label
        let tsTap = UITapGestureRecognizer(target: self, action: #selector(showTermsOfServiceWebView))
        termsOfServiceLabel?.isUserInteractionEnabled = true
        termsOfServiceLabel?.addGestureRecognizer(tsTap)

        //OnClick Gesture for Privacy Policy Label
        let ppTap = UITapGestureRecognizer(target: self, action: #selector(showPrivacyPolicyeWebView))
        privacyPolicyLabel?.isUserInteractionEnabled = true
        privacyPolicyLabel?.addGestureRecognizer(ppTap)
    }
    
    //Navigate to SignUp Controller:-
    @objc func showSignUpController(){
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        present(registerVC, animated: true)
    }
    
    //Navigate to Terms of Services WebView Page:-
    @objc func showTermsOfServiceWebView() {
        let vc = SFSafariViewController(url: URL(string: URLConstants.termsOfServiceURL)!)
        present(vc, animated: true)
    }
    
    //Navigate to Privacy Policy WebView Page:-
    @objc func showPrivacyPolicyeWebView() {
        let vc = SFSafariViewController(url : URL(string: URLConstants.privacyPolicyURL)!)
        present(vc, animated: true)
    }
    
    @IBAction func onLoginTap(_ sender: Any) {}
}

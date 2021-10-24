//
//  LoginViewController.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 16/10/21.
//

import UIKit
import SafariServices
import Firebase
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var termsOfServiceLabel: UILabel? = nil
    
    @IBOutlet weak var privacyPolicyLabel: UILabel? = nil
    
    @IBOutlet weak var createAccountLabel: UILabel? = nil
    
    @IBOutlet weak var passwordTF: UITextField? = nil
    
    @IBOutlet weak var usernameTF: UITextField? = nil
    
    var uiLoader: UIAlertController? = nil
   
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
        let registerVC = storyboard?.instantiateViewController(withIdentifier: StoryBoardViewID.SignUpViewControllerID) as? RegisterViewController
        registerVC?.modalPresentationStyle = .fullScreen
        registerVC?.modalTransitionStyle = .flipHorizontal
        dismiss(animated: true)
        present(registerVC!, animated: true)
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
    
    @IBAction func onLoginTap(_ sender: Any) {
        let loginFieldValidationMsg = validateLoginFormField()
        if(loginFieldValidationMsg.isEmpty){
            //Clean Up Username and Password fields White Spaces and fetch data from fields:-
            let userName = usernameTF?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self.showLoader()
            //Do Firebase email/Password Authentication
            let db = Firestore.firestore()
            let query = db.collection("insta_share_users").whereField("email", isEqualTo:userName!).whereField("password", isEqualTo:password!)
            query.getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    if(snapshot?.isEmpty == true){
                        //Login Authentication Error case:-
                        self.view.showToast(toastMessage: "User Authentication Failed , user does not exist", duration: 2.0 , bgColor: .red)
                    }else{
                        //Login Authentication Success case:-
                        UserDefaults.standard.set(true, forKey: PreferenceConstant.loginConstant)
                        self.view.showToast(toastMessage: "Login Success", duration: 1.5 , bgColor: .green)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.navigateToDashBoard()
                        }
                        }
                }
            }
        }else{
            self.view.showToast(toastMessage: loginFieldValidationMsg, duration: 2.0, bgColor: .red)
        }
    }
    
    //Method to Naviagte user Dashboard:-
    func navigateToDashBoard(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dashboarTabBarController = storyboard.instantiateViewController(identifier: StoryBoardViewID.DashBoardTabBarID)
        dashboarTabBarController.modalPresentationStyle = .fullScreen
        dashboarTabBarController.modalTransitionStyle = .flipHorizontal
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(dashboarTabBarController)
    }
    
    //Method to Validate Login Fields:-
    func validateLoginFormField() -> String {
        if(usernameTF?.text?.isEmpty ?? false == true){
            return "Email should not be empty!!!"
        } else if(passwordTF?.text?.isEmpty ?? false == true || passwordTF?.text?.count ?? 0 < 6){
            return "Password should not be empty!!!"
        }
        return ""
    }

//Loader Helper Functions:-
func showLoader(){
    let loader = self.loader()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.stopLoader(loader: loader)
            }
}

func loader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
    
    func stopLoader(loader : UIAlertController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true, completion: nil)
        }
    }
}

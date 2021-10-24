//
//  RegisterViewController.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 16/10/21.
//

import UIKit
import SafariServices
import FirebaseAuth
import Firebase
import FirebaseFirestore

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField? = nil
    
    @IBOutlet weak var emailTF: UITextField? = nil
    
    @IBOutlet weak var passwordTF: UITextField? = nil
    
    @IBOutlet weak var termsOfServiceLabel: UILabel? = nil
    
    @IBOutlet weak var privacyPolicyLabel: UILabel? = nil
    
    @IBOutlet weak var alreadyHaveAccountLabel: UILabel? = nil
    
    var uiLoader: UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //OnClick Gesture for Create Account Label
        let loginTap = UITapGestureRecognizer(target: self, action: #selector(showLoginController))
        alreadyHaveAccountLabel?.isUserInteractionEnabled = true
        alreadyHaveAccountLabel?.addGestureRecognizer(loginTap)
        
        //OnClick Gesture for Terms of Service Label
        let tsTap = UITapGestureRecognizer(target: self, action: #selector(showTermsOfServiceWebView))
        termsOfServiceLabel?.isUserInteractionEnabled = true
        termsOfServiceLabel?.addGestureRecognizer(tsTap)

        //OnClick Gesture for Privacy Policy Label
        let ppTap = UITapGestureRecognizer(target: self, action: #selector(showPrivacyPolicyeWebView))
        privacyPolicyLabel?.isUserInteractionEnabled = true
        privacyPolicyLabel?.addGestureRecognizer(ppTap)
    }
    
    //Navigate to Login Controller:-
    @objc func showLoginController(){
        let loginVC = storyboard?.instantiateViewController(withIdentifier: StoryBoardViewID.loginViewControllerID) as? LoginViewController
        loginVC?.modalPresentationStyle = .fullScreen
        loginVC?.modalTransitionStyle = .flipHorizontal
        dismiss(animated: true)
        present(loginVC!, animated: true)
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
    
    @IBAction func doSignUp(_ sender: Any) {
        let formValidationMsg = validateSignUpFormFields()
        if(formValidationMsg.isEmpty){
            //Clean Up All SignUp form fields White Spaces and fetch data from fields:-
            let userName = usernameTF?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let emailName = emailTF?.text?.trimmingCharacters(in:.whitespacesAndNewlines)
            let password = passwordTF?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self.showLoader()
            
            //Do Firebase email/Password Authentication
            Auth.auth().createUser(withEmail: emailName ?? "", password: password!) { response, error in
                let registerResponseUID = response?.user.uid ?? ""
                print(registerResponseUID)
                if(registerResponseUID.isEmpty){
                    DispatchQueue.main.async {
                        self.view.showToast(toastMessage: "Error in Authentication", duration: 2.0 , bgColor: .red)
                    }
                }else{
                    self.createUserINFireStoreDB(userName , emailName , password , registerResponseUID)
                }
            }
        }else{
            self.view.showToast(toastMessage: formValidationMsg, duration: 2.0, bgColor: .red)
            }
    }
    
    //Method to Validate SignUp Fields:-
    func validateSignUpFormFields() -> String {
        if(usernameTF?.text?.isEmpty ?? false == true){
            return "Username should not be empty!!!"
        } else if(emailTF?.text?.isEmpty ?? false == true){
            return "Email should not be empty!!!"
        } else if(passwordTF?.text?.isEmpty ?? false == true || passwordTF?.text?.count ?? 0 < 6){
            return "Password should not be empty or less than 6 digit!!!"
        }
        return ""
    }
    
    //Method to create User in FireStore DB:-
    func createUserINFireStoreDB(_ userName : String? , _ emailName : String? , _ password : String? ,  _ uid : String?){
        let db = Firestore.firestore()
        db.collection("insta_share_users").addDocument(data: [
            "username":userName ?? "",
            "email":emailName ?? "",
            "password":password ?? "",
            "uid":uid ?? "",
        ]) { error in
            DispatchQueue.main.async {
                if(error != nil){
                  //Create User Error case:-
                    self.view.showToast(toastMessage: "Error in Creating User in DB", duration: 2.0 , bgColor: .red)
                }else{
                  //Create User Success case:-
                    self.view.showToast(toastMessage: "Successfully Created User in DB", duration: 1.5 , bgColor: .green)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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

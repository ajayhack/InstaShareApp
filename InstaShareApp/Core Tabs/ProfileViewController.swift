//
//  ProfileViewController.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 10/10/21.
//

import UIKit

class ProfileViewController: UIViewController {
    var userEmailID : String? = nil
    var uName : String? = nil
   
   @IBOutlet var profileImage : UIImageView? = nil
    
    @IBOutlet var userName : UILabel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        userEmailID = UserDefaults.standard.object(forKey: PreferenceConstant.loggedInUserEmail) as? String
        uName = UserDefaults.standard.object(forKey: PreferenceConstant.loggedInUserName) as? String
        self.configureNavBarItems()
        userName?.text = uName
    }
    
    //Method to add User Email ID Label and Logout Button on Navigation Bar:-
    private func configureNavBarItems(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: userEmailID, style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(showLogoutActionSheet))
    }
    
    //Method to apply some style Configuration for ImageView:-
    private func configureRoundedImageView(){
        profileImage?.layer.borderWidth = 2
        profileImage?.layer.masksToBounds = true
        profileImage?.layer.borderColor = UIColor.black.cgColor
        profileImage?.layer.cornerRadius = 200
        profileImage?.clipsToBounds = true
    }
    
    //Method to show Logout Action Sheet:-
    @objc func showLogoutActionSheet(){
        let uiAlertActionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let stayOption = UIAlertAction(title: "Stay", style: .default) { stayCallBack in
           
        }
        
        let logoutOption = UIAlertAction(title: "Logout", style: .destructive) { logoutCallBack in
            
            self.doLogout()
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { cancelCallBack in
        
        }
        
        uiAlertActionController.addAction(stayOption)
        uiAlertActionController.addAction(logoutOption)
        uiAlertActionController.addAction(cancelOption)
        
        present(uiAlertActionController, animated: true, completion: nil)
    }
    
    //Method to logout User from App:-
    private func doLogout(){
        UserDefaults.standard.set(false, forKey: PreferenceConstant.loginConstant)
        UserDefaults.standard.set(nil, forKey: PreferenceConstant.loggedInUserName)
        UserDefaults.standard.set(nil, forKey: PreferenceConstant.loggedInUserEmail)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(identifier: StoryBoardViewID.loginViewControllerID)
        loginViewController.modalPresentationStyle = .fullScreen
        loginViewController.modalTransitionStyle = .flipHorizontal
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginViewController)
    }
    
    //Method to Take Picture using Camera:-
    @IBAction func openCamera(){
      let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.allowsEditing = true
        present(cameraController, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if(image != nil){
            profileImage?.image = image
        }
    }
    
}

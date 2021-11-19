//
//  ProfileViewController.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 10/10/21.
//

import UIKit
import FirebaseStorage

class ProfileViewController: UIViewController {
    var userEmailID : String? = nil
    var uName : String? = nil
    var uBio : String? = nil
    var uProfilePic : String? = nil
    var date = Date()
    var timeStamp : String? = nil
    var dateFormatType = "YY/MM/dd"
    var dateFormatter = DateFormatter()
    var imageFile : Data? = nil
    var uiLoader: UIAlertController? = nil
    var capturedImage: UIImage? = nil
   
    @IBOutlet var profileImage : UIImageView? = nil
    
    @IBOutlet var userName : UILabel? = nil
    
    @IBOutlet var userBio : UILabel? = nil
    
    var firebaseStorage = Storage.storage().reference()
    
    override func viewDidAppear(_ animated: Bool) {
        StateManageConstant.isOpenCameraContant = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        userEmailID = UserDefaults.standard.object(forKey: PreferenceConstant.loggedInUserEmail) as? String
        uName = UserDefaults.standard.object(forKey: PreferenceConstant.loggedInUserName) as? String
        uBio = UserDefaults.standard.object(forKey: PreferenceConstant.loggedInUserBio) as? String
        uProfilePic = UserDefaults.standard.object(forKey: PreferenceConstant.loggedInUserProfilePic) as? String
        self.configureNavBarItems()
        userName?.text = uName
        userBio?.text = uBio
        if(uProfilePic != nil){
            print(uProfilePic ?? "")
            self.showLoader(2)
            let url = URL(string: uProfilePic!)
            let imageLoadingTask = URLSession.shared.dataTask(with: url!, completionHandler: { data, _, error in
                guard let data = data , error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.profileImage?.image = image
                }
            })
            imageLoadingTask.resume()
        }
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
        cameraController.modalPresentationStyle = .fullScreen
        cameraController.modalTransitionStyle = .flipHorizontal
        present(cameraController, animated: true, completion: nil)
    }
    
    //Method to Save Profile Image to Firebase Cloud Storgae:-
    private func saveProfileImageToCloudStorage(){
        dateFormatter.dateFormat = dateFormatType
        self.timeStamp = dateFormatter.string(from: date).replacingOccurrences(of: "/",with: "")
        let imageName = "\(timeStamp ?? "")profile.png"
        self.showLoader(4)
        
        //Put Image to Firebase cloud storage:-
        firebaseStorage.child(imageName).putData(imageFile!, metadata: nil) { _, error in
            
            if(error == nil){
                //Profile Image Upload success
                self.view.showToast(toastMessage: "Profile image uploaded successfully", duration: 2 , bgColor: .green)
                //Getting Uploaded Image Full Download Path from Firebase Cloud Storage:-
                self.firebaseStorage.child(imageName).downloadURL { downloadURL, error in
                    if(error == nil && downloadURL != nil){
                        print(downloadURL ?? "")
                        UserDefaults.standard.set(downloadURL?.absoluteString, forKey: PreferenceConstant.loggedInUserProfilePic)
                        DispatchQueue.main.async {
                            self.profileImage?.image = self.capturedImage
                        }
                    }
                }
            }else{
                //Profile Image Upload error
                self.view.showToast(toastMessage: "Profile image upload failed", duration: 2 , bgColor: .green)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    //Get Image from Firebase Cloud Storage and Show in Profile Image View:-
    private func getProfileImageFromFirebaseCloudStorage(){
        //MARK:- GET Profile Image from Firebase Cloud Storage
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        capturedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if(capturedImage != nil){
            imageFile = capturedImage?.pngData()
            self.saveProfileImageToCloudStorage()
        }
    }
    
    //Loader Helper Functions:-
    private func showLoader(_ loaderTimeOut: Int){
        let loader = self.loader()
        let dispatchAfter = DispatchTimeInterval.seconds(loaderTimeOut)
                DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
                    self.stopLoader(loader: loader)
                }
    }
    
    private func loader() -> UIAlertController {
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.large
            loadingIndicator.startAnimating()
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            return alert
        }
        
        private func stopLoader(loader : UIAlertController) {
            DispatchQueue.main.async {
                loader.dismiss(animated: true, completion: nil)
            }
        }
}

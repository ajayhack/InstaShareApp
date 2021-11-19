//
//  CameraViewController.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 10/10/21.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class CameraViewController: UIViewController {
    
    @IBOutlet var postImage : UIImageView? = nil
    
    @IBOutlet var postDescription : UITextField? = nil
    
    @IBOutlet var postLocation : UITextField? = nil
    
    var uiLoader: UIAlertController? = nil
    var timeStamp : String? = nil
    var imageFile : Data? = nil
    
    var firebaseStorage = Storage.storage().reference()
    
    override func viewDidAppear(_ animated: Bool) {
        if(!StateManageConstant.isOpenCameraContant){
            postImage?.isHidden = true
            postDescription?.isHidden = true
            postLocation?.isHidden = true
            showNavigationBar(false)
        self.openCamera()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Method to setup navigation Bar:-
    private func showNavigationBar(_ isSetUpNavBar : Bool){
        if(isSetUpNavBar){
        self.navigationController?.navigationBar.tintColor = .black
        self.configureNavBarItems()
        }
    }
    
    //Method to add Instagram Logo and Share Post Button on Navigation Bar:-
    private func configureNavBarItems(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Instagram", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(savePostImageToCloudStorage))
    }
    
    private func doSharePost(_ imageURL : String?){
        //MARK: Need To Add Firebase Cloud to Store Images Data and Also FireStore Collection to Store Post Related Data:-
        let postValidationMsg = validatePostFields()
        let postDescription = postDescription?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let postLocation = postLocation?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userUid = UserDefaults.standard.object(forKey: PreferenceConstant.loggedInUserUID) as? String
        //Save Post Meta Data in Firebase FireStore Collection
        if(postValidationMsg.isEmpty){
        let db = Firestore.firestore()
        db.collection("post_share").addDocument(data: [
            "post_description":postDescription ?? "",
            "post_location":postLocation ?? "",
            "post_date":timeStamp ?? "",
            "post_like":false,
            "user_uid":userUid ?? "",
            "post_image":imageURL ?? ""
        ]) { error in
            DispatchQueue.main.async {
                if(error != nil){
                  //Create Post Error case:-
                    self.view.showToast(toastMessage: "Post data upload failed", duration: 2.0 , bgColor: .red)
                }else{
                    //Create Post Success case:-
                    self.view.showToast(toastMessage: "Post shared successfully", duration: 2 , bgColor: .green)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            }
        }
    }else{
            self.view.showToast(toastMessage: postValidationMsg, duration: 2.0, bgColor: .red)
            }
    }
    
    //Method to Validate Post Fields:-
    private func validatePostFields() -> String {
        if(imageFile?.isEmpty ?? false == true){
            return "Please select post image!!!"
        }
        else if(postDescription?.text?.isEmpty ?? false == true){
            return "Post description should not be empty!!!"
        } else if(postLocation?.text?.isEmpty ?? false == true){
            return "Post Location should not be empty!!!"
        }
        return ""
    }
    
    //Method to Save Post Image to Firebase Cloud Storgae:-
    @objc func savePostImageToCloudStorage(){
        timeStamp = generateCurrentTimeStamp()
        let imageName = "\(timeStamp ?? "")images.png"
        self.showLoader()
        
        //Put Image to Firebase cloud storage:-
        firebaseStorage.child(imageName).putData(imageFile!, metadata: nil) { _, error in
            
            if(error == nil){
                //Post Image Upload success Now Getting Download Absolute URL of Image to store that with other Post Data:-
                self.firebaseStorage.child(imageName).downloadURL { downloadURL, error in
                    //Download URL Success Case:-
                    if(error == nil && downloadURL != nil){
                        self.doSharePost(downloadURL?.absoluteString)
                    }else{
                        //Download URL Failure Case:-
                        self.view.showToast(toastMessage: "Download Post image failed", duration: 2 , bgColor: .green)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }else{
                //Post Image Upload error
                self.view.showToast(toastMessage: "Post image upload failed", duration: 2 , bgColor: .green)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
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
}

extension CameraViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.tabBarController?.selectedIndex = 0
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if(image != nil){
            postImage?.image = image
            postImage?.isHidden = false
            postDescription?.isHidden = false
            postLocation?.isHidden = false
            showNavigationBar(true)
            StateManageConstant.isOpenCameraContant = true
            imageFile = image?.pngData()
        }
    }
    
    //Loader Helper Functions:-
    private func showLoader(){
        let loader = self.loader()
                DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
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

//
//  ExploreViewController.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 10/10/21.
//

import UIKit
import Firebase
import SafariServices
import FirebaseFirestore

class ExploreViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var postTableView : UITableView? = nil
    var uiLoader: UIAlertController? = nil
    var postDataList = [PostModal]()
   
    @IBOutlet weak var searchTF: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        StateManageConstant.isOpenCameraContant = false
        self.loadAllPostData("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBarItems()
        self.postTableView?.register(UINib(nibName: StoryBoardViewID.CustomTableViewID,    bundle: nil),forCellReuseIdentifier: StoryBoardViewID.CustomTableViewID)
        self.postTableView?.delegate = self
        self.postTableView?.dataSource = self
    }
    
    //Method to add Instagram Logo on Navigation Bar:-
    private func configureNavBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Instagram", style: .done, target: self, action: nil)
    }
    
    //Search Text Field Text Change Event Listener
    @IBAction func onSearchTFChangedEvent(_ sender: Any) {
        print("Search Text \(searchTF.text ?? "")")
        if(searchTF.text?.isEmpty == true){
            postDataList.removeAll()
            postTableView?.reloadData()
        }else {
        self.loadAllPostData(searchTF.text ?? "")
        }
    }
    
    //Method to get all post data from Firebase Firestore:-
    private func loadAllPostData(_ searchText : String){
        if(searchText.isEmpty){
            return
        }else {
        let db = Firestore.firestore()
        let query = db.collection("post_share")
        postDataList.removeAll()
        self.showLoader(5)
        query.getDocuments { snapshot, error in
            DispatchQueue.main.async {
                if(snapshot?.isEmpty == true){
                    //Post Fetching Error case:-
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        self.view.showToast(toastMessage: "No Data Found!! , Create a Post", duration: 2.0 , bgColor: .red)
                    }
                    
                }else{
                    //Post Fetching Success case:-
                    //Mapping Post Data objects to PostDataList:-
                    let userName = UserDefaults.standard.object(forKey: PreferenceConstant.loggedInUserName) as? String
                    for document in snapshot!.documents {
                                print("UserData:- \(document.documentID) => \(document.data())")
                    let documentData = document.data()
                    let location = documentData["post_location"] as? String
                    let description = documentData["post_description"] as? String
                    let like = documentData["post_like"] as? Bool
                    let imageURL = documentData["post_image"] as? String
                    let postTimeStamp = documentData["post_date"] as? String
                        if(location?.range(of: searchText) != nil){
                        self.postDataList.append(PostModal(postUserName: userName, postLocation: location, postImageURL: imageURL, postDescription: description, postLike: like , postTimeStamp: postTimeStamp))
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        var postLoadMsg = ""
                        if(self.postDataList.isEmpty == true){
                            postLoadMsg = "No Post Data Found"
                            self.view.showToast(toastMessage: postLoadMsg, duration: 1.5 , bgColor: .red)
                        }else{
                            postLoadMsg = "Post Data Loaded"
                            self.view.showToast(toastMessage: postLoadMsg, duration: 1.5 , bgColor: .green)
                        }
                        self.postTableView?.reloadData()
                    }
            }
        }
    }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView?.dequeueReusableCell(withIdentifier: StoryBoardViewID.CustomTableViewID, for: indexPath) as! CustomTableViewCell
        let modal = postDataList[indexPath.row]
        cell.userNameLabel?.text = modal.postUserName
        cell.descriptionLabel?.text = modal.postDescription
        cell.locationLabel?.text = modal.postLocation
        if(modal.postLike == true){
            cell.likeButton?.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
            cell.tintColor = .red
        }else{
            cell.likeButton?.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
        }
        cell.likeButton?.isHidden = true
        cell.sharebutton?.isHidden = true
        let url = URL(string: modal.postImageURL!)
        let imageLoadingTask = URLSession.shared.dataTask(with: url!, completionHandler: { data, _, error in
            guard let data = data , error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                cell.postImage?.image = image
            }
        })
        imageLoadingTask.resume()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(postDataList[indexPath.row])
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

//
//  Utility.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 18/10/21.
//

import Foundation
import SafariServices
import UIKit

struct URLConstants {
    static let termsOfServiceURL = "https://www.instagram.com/about/legal/terms/before-january-19-2013/"
    static let privacyPolicyURL = "https://www.instagram.com/terms/accept/?hl=en"
}

struct StoryBoardViewID {
    static let loginViewControllerID = "login"
    static let SignUpViewControllerID = "signup"
    static let DashBoardTabBarID = "dashboardTabBar"
    static let ProfileViewControllerID = "profile"
    static let CustomTableViewID = "CustomTableViewCell"
}

struct PreferenceConstant {
    static let loginConstant = "login"
    static let loggedInUserName = "uName"
    static let loggedInUserEmail = "uEmail"
    static let loggedInUserBio = "uBio"
    static let loggedInUserUID = "uUid"
    static let loggedInUserProfilePic = "uProfilePic"
}

struct StateManageConstant {
    static var isOpenCameraContant = false
}

struct PostModal {
    var postUserName : String? = nil
    var postLocation : String? = nil
    var postImageURL : String? = nil
    var postDescription : String? = nil
    var postLike : Bool? = false
    var postTimeStamp : String? = nil
}

func generateCurrentTimeStamp () -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
    return (formatter.string(from: Date()) as NSString) as String
}


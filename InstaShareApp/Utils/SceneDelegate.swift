//
//  SceneDelegate.swift
//  InstaShareApp
//
//  Created by Ajay Thakur on 10/10/21.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let windowScene = scene as? UIWindowScene
        let window = UIWindow(windowScene: windowScene!)
        if(!checkLogin() && windowScene != nil){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: StoryBoardViewID.loginViewControllerID)
        initialViewController.modalPresentationStyle = .fullScreen
             window.rootViewController = initialViewController
             self.window = window
             window.makeKeyAndVisible()
        }else { return }
    }
    
    //Method to Change Scene First Screen Window at Runtime:-
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true){
        window?.rootViewController = vc
    }
    
    //Method to Check if User Already Login then redirect to Tabbed Controller:-
    func checkLogin() -> Bool{
        let loginStatus = UserDefaults.standard
        if loginStatus.object(forKey: PreferenceConstant.loginConstant) == nil {
            //User not Logged In Case:-
            print("ERROR:- Login Required Redirect to Login Controller")
            return false
        } else {
            if(loginStatus.bool(forKey: PreferenceConstant.loginConstant)){
            //User Logged in Case:-
             return true
            }
        }
        return false
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


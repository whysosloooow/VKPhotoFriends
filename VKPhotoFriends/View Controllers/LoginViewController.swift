//
//  LoginViewController.swift
//  VKPhotoFriends
//
//  Created by Igor Grankin on 24.04.2018.
//  Copyright © 2018 Igor Grankin. All rights reserved.
//

import UIKit
import VK_ios_sdk

class LoginViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate, UIAlertViewDelegate {
    let userDefaultsString = "kCurrentUserToken"
    let scope = [VK_PER_FRIENDS, VK_PER_EMAIL, VK_PER_WALL]
    override func viewDidLoad() {
        super.viewDidLoad()
        VKSdk.initialize(withAppId: "6459934")
        VKSdk.instance().register(self)
        VKSdk.instance().uiDelegate = self
        //REMOVE LATER
//        VKSdk.forceLogout()
        [VKSdk.wakeUpSession(scope, complete: { (state, error) in
            if ((error) != nil) {
                print("logging error, no active session")
            } else {
                let savedToken = VKAccessToken.savedToken(self.userDefaultsString)
                if (((savedToken?.accessToken) != nil) && !(savedToken?.isExpired())! && (state == .authorized || state == .pending)) {
                    self.changeScreenAfterSuccess()
                }
            }
        })]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        VKSdk.authorize(scope)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func changeScreenAfterSuccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PhotosTabBarID")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func vkSdkAuthorizationStateUpdated(with result: VKAuthorizationResult!) {
    }
    
    //    MARK: -
    //    MARK: VK Delegate methods
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if ((result.state == .authorized || result.state == .pending) && (result.token != nil)) {
            self.changeScreenAfterSuccess()
        }
    }
    func vkSdkAccessTokenUpdated(_ newToken: VKAccessToken!, oldToken: VKAccessToken!) {
        if (newToken == nil) {
            VKAccessToken.delete(userDefaultsString)
        } else {
            let userToken = VKAccessToken.init(token: newToken.accessToken, secret: newToken.secret, userId: newToken.userId)
            userToken?.save(toDefaults: userDefaultsString)
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        
    }
    
    //    MARK: -
    //    MARK: VK UI Delegate methods
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }

}

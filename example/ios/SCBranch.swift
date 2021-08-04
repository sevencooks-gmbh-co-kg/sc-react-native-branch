//
//  SCBranch.swift
//  scapp
//
//  Created by Piquant Earthqake on 08.07.21.
//

import Foundation

@objc
class SCBranch: NSObject {
  @objc
  func configureLaunchOptions(_ options: NSDictionary) {
    Branch.setTrackingDisabled(true)
    UserDefaults.standard.setValue(options, forKey: "SCAppLaunchOptions")
  }
  
  @objc
  func application(_ app: UIApplication, url: URL, options: [UIApplication.OpenURLOptionsKey : Any]?) -> Bool {
    Branch.getInstance().application(app, open: url, options: options)
    return true
  }
  
  @objc
  func continueUserActivity(_ activity: NSUserActivity) -> Bool {
    Branch.getInstance().continue(activity)
    return true
  }
}

//
//  SCBranchBridge.swift
//  scapp
//
//  Created by Piquant Earthqake on 09.07.21.
//

import Foundation

func linkPropertiesFromBridgeWith(_ linkInfo: Dictionary<String, Any>) -> BranchLinkProperties {
  let linkProperties = BranchLinkProperties.init()

  linkInfo.forEach({ key, value in
    if key.hasPrefix("$") {
      linkProperties.addControlParam(key, withValue: value as? String)
      return
    }

    if (key == "feature") {
      linkProperties.feature = value as? String
    }
    if (key == "channel") {
      linkProperties.channel = value as? String
    }

    if (key == "tags") {
      linkProperties.tags = value as? [String]
    }

    if (key == "alias") {
      linkProperties.alias = value as? String
    }

    if (key == "stage") {
      linkProperties.stage = value as? String
    }

    if (key == "campaign") {
      linkProperties.campaign = value as? String
    }
  })

  return linkProperties
}

func unversalObjectFromBrigeWith(_ linkInfo: Dictionary<String, Any>) -> BranchUniversalObject {
  let canonicalIdentifier = linkInfo["canonicalIdentifier"]
  let universalObject = BranchUniversalObject.init(canonicalIdentifier: canonicalIdentifier as! String)

  linkInfo.forEach({ key, value in
    if (key == "title") {
      universalObject.title = value as? String
    }

    if (key == "contentDescription") {
      universalObject.contentDescription = value as? String
    }

    if (key == "imageUrl") {
      universalObject.imageUrl = value as? String
    }

    if (key == "canonicalIdentifier") {
      universalObject.canonicalIdentifier = value as? String
    }

    if (key == "canonicalUrl") {
      universalObject.canonicalUrl = value as? String
    }

    if (key == "keywords") {
      universalObject.keywords = value as? [String]
    }

  })

  return universalObject
}

let EVENT_LinkAvailable = "LinkAvailable"

@objc(SCBranchManager)
class SCBranchManager: RCTEventEmitter  {
  var hasListeners: Bool = false

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return false
  }

  @objc
  override func startObserving() {
    hasListeners = true
  }

  @objc
  override func stopObserving() {
    hasListeners = false
  }

  @objc
  override func constantsToExport() -> [AnyHashable: Any]! {
    // naming of the constant must be identical to the naming expected in JS and also defined in Kotlin for the Android side
    return ["INIT_SESSION_FINISHED": EVENT_LinkAvailable]
  }

  @objc
  override func supportedEvents() -> [String] {
    return [EVENT_LinkAvailable]
  }

  @objc
  func initSession() {
    let launchOptions = UserDefaults.standard.dictionary(forKey: "SCAppLaunchOptions")
    Branch.getInstance().initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { params, error in
      guard self.hasListeners == true else {
        return
      }
      guard error == nil else {
        NSLog(error.debugDescription)
        self.sendEvent(withName: EVENT_LinkAvailable, body: [
          "error": error.debugDescription,
        ])
        return
      }
      NSLog("SCLog: Branch SDK init:")
      NSLog("SCLog: \(String(describing: params))")
      self.sendEvent(withName: EVENT_LinkAvailable, body: [
        "params": params
      ])
    })
  }

  @objc
  func validateSDKIntegration() {
    Branch.getInstance().validateSDKIntegration()
  }

  @objc
  func getLatestReferringParams(_ resolve: RCTPromiseResolveBlock, rejecter reject:RCTPromiseRejectBlock) {
    // https://help.branch.io/developers-hub/docs/ios-full-reference#retrieve-session-install-or-open-parameters
    // We have to bad choices here 1. maybe get the latest results maybe not 2. block the whole app and get the correct results.
    // See Branch doc for no explaination why and prefere subscribe
    let sessionParams = Branch.getInstance().getLatestReferringParams()
    resolve(sessionParams)
  }

  @objc
  func getFirstReferringParams(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    let firstParams = Branch.getInstance().getFirstReferringParams()
    return resolve(firstParams)
  }

  @objc
  func generateShortUrl(_ branchUniversalObject: Dictionary<String, Any>, linkProperties: Dictionary<String, Any>, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    let linProperties = linkPropertiesFromBridgeWith(branchUniversalObject)
    let universalObject = unversalObjectFromBrigeWith(linkProperties)

    let link = universalObject.getShortUrl(with: linProperties)
    guard link != nil else {
      reject("scbranch_failure", "Branch does not provide error details", nil)
      return
    }
    resolve(link)
  }
}

import Branch

@objc(ScReactNativeBranch)
class ScReactNativeBranch: NSObject {

    @objc(multiply:withB:withResolver:withRejecter:)
    func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        print("multiply called")
        // if you are using the TEST key
        Branch.setUseTestBranchKey(true)
        // listener for Branch Deep Link data
        Branch.getInstance().initSession(launchOptions: [:]) { (params, error) in
             // do stuff with deep link data (nav to page, display content, etc)
            print("branch callback called!")
            print(params as? [String: AnyObject] ?? {})
        }
        
        resolve(a*b)
    }
}

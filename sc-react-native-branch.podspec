require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "sc-react-native-branch"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/NehrDani/sc-react-native-branch.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"

  # https://blog.cocoapods.org/CocoaPods-1.5.0/
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }

  # TODO: figure this out
  s.dependency 'Branch', '1.39.2'
  s.dependency "React-Core"
end

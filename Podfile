platform :ios, '13.6'

def shared_pods
  pod 'Alamofire'
  pod 'SwiftLint'
end

target 'EventyayOrganizer' do
  use_frameworks!
  # Pods for EventyayOrganizer
  pod 'Motion'
  pod 'Material'
  pod 'M13Checkbox'
  pod 'ObjectMapper'
  pod 'AlamofireObjectMapper', :git => 'https://github.com/T-Pro/AlamofireObjectMapper.git', :branch => 'master'
  pod 'NVActivityIndicatorView'
  shared_pods
end

  target 'EventyayOrganizerUITests' do
    use_frameworks!
    shared_pods
end

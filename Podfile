def import_pods
  pod 'web3swift', '~> 2.0.4', :modular_headers => true
end

target 'PlasmaSwiftLib' do
  platform :ios, '9.0'
  
  use_modular_headers!
  #use_frameworks!
  import_pods

  target 'PlasmaSwiftLibTests' do
    inherit! :search_paths
  end

end


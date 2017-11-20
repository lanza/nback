# vim: set ft=ruby :

target 'nBack' do
  use_frameworks!

  pod 'SwiftyJSON'

  pod 'RxSwift', ' 3.5.0'
  pod 'RxCocoa', '3.5.0'
  pod 'RxDataSources', '1.0.3'
  pod 'RealmSwift', '2.7.0'
  pod 'RxRealm', '0.6.0'

  pod 'DZNEmptyDataSet'
  pod 'BonMot', '4.1'
  pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka', :branch => 'feature/Xcode9-Swift3_2'

  pod 'Hero', '0.3.6'

  target 'nBackTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end


  if `whoami`[0...-1] == 'alanza'
    pod 'CoordinatorKit', :path => '~/Documents/CoordinatorKit'
    pod 'Reuse', :path => '~/Documents/Reuse'
  else 
    pod 'CoordinatorKit', :git => 'https://github.com/nathanlanza/CoordinatorKit'
    pod 'Reuse', :git=> 'https://github.com/nathanlanza/Reuse'
  end

  target 'nBackInternal' do
    inherit! :search_paths
  end
end

# vim : set ft=ruby :

def podsForTarget(target)

  target target do
    use_frameworks!

    pod 'SwiftyJSON'
    
    if `whoami`[0...-1] == 'lanza'
      pod 'CoordinatorKit', :path => '~/Documents/CoordinatorKit'
      pod 'Reuse', :path => '~/Documents/Reuse'
    else 
      pod 'CoordinatorKit', :git => 'https://github.com/nathanlanza/CoordinatorKit'
      pod 'Reuse', :git=> 'https://github.com/nathanlanza/Reuse'
    end

    pod 'RxSwift', '~> 3.2'
    pod 'RxCocoa', '~> 3.2'
    pod 'RxDataSources'
    pod 'RealmSwift'
    pod 'RxRealm'

    pod 'DZNEmptyDataSet'
    pod 'BonMot'
    pod 'Eureka', '~> 2.0.0-beta.1'

    pod 'Hero'

  end
end

podsForTarget 'nBack'
podsForTarget 'nBackInternal'
podsForTarget 'nBackTests'

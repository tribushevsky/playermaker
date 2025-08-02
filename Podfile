platform :ios, '15.0'

target 'PlayermakerTrybusheusky' do
	use_frameworks!

	pod 'RxSwift', '= 6.9.0'
	pod 'RxCocoa', '= 6.9.0'
	pod 'SnapKit', '~> 5.7.1'
	pod 'SwiftGen', '~> 6.6'
	pod 'Swinject', '~> 2.8'
	pod 'RealmSwift', '~> 10.32.3'
	pod 'RxRealm', '~> 5.0.4'
	pod 'RxDataSources', :git => 'https://github.com/tribushevsky/RxDataSources.git', :branch => 'main'

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
				config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
			end
		end
	end
 end

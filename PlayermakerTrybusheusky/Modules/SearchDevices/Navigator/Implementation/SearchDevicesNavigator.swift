//
//  SearchDevicesNavigator.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift

final class SearchDevicesNavigator: NavigatorErrorCatcher<Void>, SearchDevicesNavigatorProtocol {

	func routeToEditDevice(device: FavoriteDeviceModel) -> Observable<FavoriteDeviceModel> {
		guard let navigationController = navigationController else {
			return Observable.fatalEmpty(msg: "\(#function): currentView in nil")
		}

		let editDeviceView = dependencyResolver.editDevice(device: device)

		return navigationController.rx.present(editDeviceView, animated: true)
			.map { [unowned editDeviceView] in editDeviceView.viewModel.navigator }
			.flatMapLatest { $0.output }
			.do(onCompleted: { [weak navigationController] in
				navigationController?.dismiss(animated: true)
			})
	}

	func showAppSettings() -> Observable<Void> {
		guard
			let bundleIdentifier = Bundle.main.bundleIdentifier,
			let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier),
			UIApplication.shared.canOpenURL(appSettings)
		else {
			return Observable.never()
		}

		UIApplication.shared.open(appSettings)

		return Observable.just(Void())
	}

}

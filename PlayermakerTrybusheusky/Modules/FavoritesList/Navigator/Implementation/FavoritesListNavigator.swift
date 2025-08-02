//
//  FavoritesListNavigator.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift

final class FavoritesListNavigator: NavigatorErrorCatcher<Void>, FavoritesListNavigatorProtocol {

	func routeToSearchDevices() -> Observable<Void> {
		guard let currentView = currentView else {
			return Observable.fatalEmpty(msg: "\(#function): currentView in nil")
		}

		let searchNavigationController = UINavigationController()
		let searchView = dependencyResolver.searchDevices(navigationController: searchNavigationController)

		return currentView.rx.present(searchNavigationController, animated: true)
			.map { [unowned searchView] in searchView.viewModel.navigator }
			.flatMapLatest { $0.output }
			.do(onCompleted: { [weak currentView] in
				currentView?.dismiss(animated: true)
			})
	}

	func routeToEditDevice(device: FavoriteDeviceModel) -> Observable<FavoriteDeviceModel> {
		guard let currentView = currentView else {
			return Observable.fatalEmpty(msg: "\(#function): currentView in nil")
		}

		let editDeviceView = dependencyResolver.editDevice(device: device)

		return currentView.rx.present(editDeviceView, animated: true)
			.map { [unowned editDeviceView] in editDeviceView.viewModel.navigator }
			.flatMapLatest { $0.output }
			.do(onCompleted: { [weak currentView] in
				currentView?.dismiss(animated: true)
			})
	}

}

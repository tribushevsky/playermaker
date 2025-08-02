//
//  RootNavigator.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import RxSwift

final class RootNavigator: Navigator<Void>, RootNavigatorProtocol {
	
	func routeToLaunch(developerName: String) -> Observable<Void> {
		guard
			let currentWindow
		else {
			return Observable.fatalEmpty(msg: "\(#function): currentWindow in nil")
		}

		currentWindow.rootViewController = dependencyResolver.launch(
			developerName: developerName
		)
		return Observable<Void>.just(Void())
	}

	func routeToFavoritesList() -> Observable<Void> {
		guard
			let currentWindow
		else {
			return Observable.fatalEmpty(msg: "\(#function): currentWindow in nil")
		}

		let favoritesListView = dependencyResolver.favoritesList()
		return currentWindow.rx.setRootViewController(
			favoritesListView,
			animated: true,
			duration: 0.7,
			options: .transitionFlipFromLeft
		)
		.map { [unowned favoritesListView] in favoritesListView.viewModel.navigator }
		.flatMapLatest { $0.output }

	}
	
}

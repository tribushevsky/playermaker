//
//  NavigationDependencyResolver.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 29/07/2025.
//

import Swinject

final class NavigationDependencyResolver {

	private let resolver: Resolver

	init(resolver: Resolver) {
		self.resolver = resolver
	}

}

// MARK: - NavigationDependencyResolverProtocol

extension NavigationDependencyResolver: NavigationDependencyResolverProtocol {

	func root(windowScene: UIWindowScene) -> RootView {
		resolver.resolve(RootView.self, argument: windowScene)!
	}

	func launch(developerName: String) -> LaunchView {
		resolver.resolve(LaunchView.self, argument: developerName)!
	}

	func favoritesList() -> FavoritesListView {
		resolver.resolve(FavoritesListView.self)!
	}

	func searchDevices(navigationController: UINavigationController) -> SearchDevicesView {
		return resolver.resolve(SearchDevicesView.self, argument: navigationController)!
	}

	func editDevice(device: FavoriteDeviceModel) -> EditDeviceView {
		resolver.resolve(EditDeviceView.self, argument: device)!
	}

}

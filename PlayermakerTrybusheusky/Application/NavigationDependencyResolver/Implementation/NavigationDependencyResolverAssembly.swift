//
//  NavigationDependencyResolverAssembly.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import Swinject

final class NavigationDependencyResolverAssembly: Assembly {

	public func assemble(container: Container) {
		registerNavigationDependencyResolver(container: container)
		registerRoot(container: container)
		registerLaunch(container: container)
		registerFavoritesList(container: container)
		registerSearchDevices(container: container)
		registerEditDevice(container: container)
	}

}

// MARK: - Registration / Dependency Resolver

extension NavigationDependencyResolverAssembly {

	private func registerNavigationDependencyResolver(container: Container) {
		container.register(NavigationDependencyResolver.self) { resolver in
			NavigationDependencyResolver(resolver: resolver)
		}.inObjectScope(.weak)
	}

}


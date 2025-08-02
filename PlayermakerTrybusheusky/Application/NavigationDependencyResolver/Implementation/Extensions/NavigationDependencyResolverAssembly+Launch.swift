//
//  NavigationDependencyResolverAssembly+Launch.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import Swinject

// MARK: - Registrations / Launch

extension NavigationDependencyResolverAssembly {

	func registerLaunch(container: Container) {
		container.register(LaunchView.self) { (resolver, developerName: String) in
			LaunchView(viewModel: resolver.resolve(LaunchViewModel.self, argument: developerName)!)
		}.inObjectScope(.transient)

		container.register(LaunchViewModel.self) { (resolver, developerName: String) in
			LaunchViewModel(
				context: resolver.resolve(LaunchContextProtocol.self, argument: developerName)!,
				useCase: resolver.resolve(LaunchUseCaseProtocol.self)!,
				navigator: resolver.resolve(LaunchNavigatorProtocol.self)!
			)
		}.inObjectScope(.transient)

		container.register(LaunchContextProtocol.self) { (_, developerName: String) in
			LaunchContext(developerName: developerName)
		}.inObjectScope(.transient)

		container.register(LaunchUseCaseProtocol.self) { resolver in
			LaunchUseCase(
				dependencies: resolver.resolve(LaunchDependenciesProtocol.self)!
			)
		}.inObjectScope(.transient)

		container.register(LaunchNavigatorProtocol.self) { resolver in
			LaunchNavigator(
				dependencyResolver: resolver.resolve(NavigationDependencyResolver.self)!
			)
		}.inObjectScope(.transient)

		container.register(LaunchDependenciesProtocol.self) { resolver in
			LaunchDependencies()
		}.inObjectScope(.transient)
	}

}

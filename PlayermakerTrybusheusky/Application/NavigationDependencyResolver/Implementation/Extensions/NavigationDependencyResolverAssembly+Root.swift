//
//  Untitled.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import Swinject
import UIKit

// MARK: - Registrations / Root

extension NavigationDependencyResolverAssembly {

	func registerRoot(container: Container) {
		container.register(RootView.self) { (resolver, windowScene: UIWindowScene) in
			RootView(
				viewModel: resolver.resolve(RootViewModel.self)!,
				windowScene: windowScene
			)
		}.initCompleted { _, view in
			view.viewModel.navigator.currentWindow = view
		}.inObjectScope(.transient)

		container.register(RootViewModel.self) { resolver in
			RootViewModel(
				context: resolver.resolve(RootContextProtocol.self)!,
				useCase: resolver.resolve(RootUseCaseProtocol.self)!,
				navigator: resolver.resolve(RootNavigatorProtocol.self)!
			)
		}.inObjectScope(.transient)

		container.register(RootContextProtocol.self) { _ in
			RootContext()
		}.inObjectScope(.transient)

		container.register(RootUseCaseProtocol.self) { resolver in
			RootUseCase(
				dependencies: resolver.resolve(RootDependenciesProtocol.self)!
			)
		}.inObjectScope(.transient)

		container.register(RootNavigatorProtocol.self) { resolver in
			RootNavigator(
				dependencyResolver: resolver.resolve(NavigationDependencyResolver.self)!
			)
		}.inObjectScope(.transient)

		container.register(RootDependenciesProtocol.self) { resolver in
			RootDependencies(
				identityService: resolver.resolve(IdentityServiceProtocol.self)!
			)
		}.inObjectScope(.transient)
	}

}


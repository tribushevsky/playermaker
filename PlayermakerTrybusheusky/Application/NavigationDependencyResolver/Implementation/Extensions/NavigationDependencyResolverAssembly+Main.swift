//
//  NavigationDependencyResolverAssembly+Main.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import Swinject

// MARK: - Registrations / Main

extension NavigationDependencyResolverAssembly {

	func registerFavoritesList(container: Container) {
		container.register(FavoritesListView.self) { resolver in
			FavoritesListView(viewModel: resolver.resolve(FavoritesListViewModel.self)!)
		}
		.initCompleted { _, view in
			view.viewModel.navigator.currentView = view
		}
		.inObjectScope(.transient)

		container.register(FavoritesListViewModel.self) { resolver in
			FavoritesListViewModel(
				context: resolver.resolve(FavoritesListContextProtocol.self)!,
				useCase: resolver.resolve(FavoritesListUseCaseProtocol.self)!,
				navigator: resolver.resolve(FavoritesListNavigatorProtocol.self)!
			)
		}.inObjectScope(.transient)

		container.register(FavoritesListContextProtocol.self) { _ in
			FavoritesListContext()
		}.inObjectScope(.transient)

		container.register(FavoritesListUseCaseProtocol.self) { resolver in
			FavoritesListUseCase(
				dependencies: resolver.resolve(FavoritesListDependenciesProtocol.self)!
			)
		}.inObjectScope(.transient)

		container.register(FavoritesListNavigatorProtocol.self) { resolver in
			FavoritesListNavigator(
				dependencyResolver: resolver.resolve(NavigationDependencyResolver.self)!
			)
		}.inObjectScope(.transient)

		container.register(FavoritesListDependenciesProtocol.self) { resolver in
			FavoritesListDependencies(
				storage: resolver.resolve(ReactiveLocalStorageServiceProtocol.self)!
			)
		}.inObjectScope(.transient)
	}

	func registerSearchDevices(container: Container) {
		container.register(SearchDevicesView.self) { (resolver, navigationController: UINavigationController) in
			SearchDevicesView(viewModel: resolver.resolve(SearchDevicesViewModel.self, argument: navigationController)!)
		}.initCompleted { _, view in
			view.viewModel.navigator.navigationController?.setViewControllers([view], animated: false)
		}
		.inObjectScope(.transient)

		container.register(SearchDevicesViewModel.self) { (resolver, navigationController: UINavigationController) in
			SearchDevicesViewModel(
				context: resolver.resolve(SearchDevicesContextProtocol.self)!,
				useCase: resolver.resolve(SearchDevicesUseCaseProtocol.self)!,
				navigator: resolver.resolve(SearchDevicesNavigatorProtocol.self, argument: navigationController)!
			)
		}.inObjectScope(.transient)

		container.register(SearchDevicesContextProtocol.self) { _ in
			SearchDevicesContext()
		}.inObjectScope(.transient)

		container.register(SearchDevicesUseCaseProtocol.self) { resolver in
			SearchDevicesUseCase(
				dependencies: resolver.resolve(SearchDevicesDependenciesProtocol.self)!
			)
		}.inObjectScope(.transient)

		container.register(SearchDevicesNavigatorProtocol.self) { (resolver, navigationController: UINavigationController) in
			SearchDevicesNavigator(
				navigationController: navigationController,
				dependencyResolver: resolver.resolve(NavigationDependencyResolver.self)!
			)
		}.inObjectScope(.transient)

		container.register(SearchDevicesDependenciesProtocol.self) { resolver in
			SearchDevicesDependencies()
		}.inObjectScope(.transient)
	}

	func registerEditDevice(container: Container) {
		container.register(EditDeviceView.self) { resolver in
			EditDeviceView(viewModel: resolver.resolve(EditDeviceViewModel.self)!)
		}.inObjectScope(.transient)

		container.register(EditDeviceViewModel.self) { resolver in
			EditDeviceViewModel(
				context: resolver.resolve(EditDeviceContextProtocol.self)!,
				useCase: resolver.resolve(EditDeviceUseCaseProtocol.self)!,
				navigator: resolver.resolve(EditDeviceNavigatorProtocol.self)!
			)
		}.inObjectScope(.transient)

		container.register(EditDeviceContextProtocol.self) { _ in
			EditDeviceContext()
		}.inObjectScope(.transient)

		container.register(EditDeviceUseCaseProtocol.self) { resolver in
			EditDeviceUseCase(
				dependencies: resolver.resolve(EditDeviceDependenciesProtocol.self)!
			)
		}.inObjectScope(.transient)

		container.register(EditDeviceNavigatorProtocol.self) { resolver in
			EditDeviceNavigator(
				dependencyResolver: resolver.resolve(NavigationDependencyResolver.self)!
			)
		}.inObjectScope(.transient)

		container.register(EditDeviceDependenciesProtocol.self) { resolver in
			EditDeviceDependencies()
		}.inObjectScope(.transient)
	}

}

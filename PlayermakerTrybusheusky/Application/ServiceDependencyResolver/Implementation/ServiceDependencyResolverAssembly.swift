//
//  ServiceDependencyResolverAssembly.swift
//  PlayermakerTrybusheusky
//
//  Created by Uladzimir Trybusheusky on 30/07/2025.
//

import Swinject

final class ServiceDependencyResolverAssembly: Assembly {

	public func assemble(container: Container) {
		registerDependencyResolver(container: container)
		registerIdentityService(container: container)
		registerLocalStorageService(container: container)
		registerBluetoothService(container: container)
	}

}

// MARK: - Registration

extension ServiceDependencyResolverAssembly {

	func registerDependencyResolver(container: Container) {
		container.register(ServiceDependencyResolverProtocol.self) { resolver in
			ServiceDependencyResolver(resolver: resolver)
		}.inObjectScope(.weak)
	}

	func registerIdentityService(container: Container) {
		container.register(IdentityServiceProtocol.self) { _ in
			StaticIdentityService()
		}.inObjectScope(.container)
	}

	func registerLocalStorageService(container: Container) {
		container.register(ReactiveLocalStorageServiceProtocol.self) { _ in
			guard let service = try? RealmLocalStorageService() else {
				fatalError("Local storage initialization error")
			}

			return service
		}.inObjectScope(.container)
	}

	func registerBluetoothService(container: Container) {
		container.register(BluetoothServiceProtocol.self) { resolver in
			BluetoothService()
		}.inObjectScope(.container)
	}

}
